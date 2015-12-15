//+------------------------------------------------------------------+
//|                                                  My_First_EA.mq4 |
//|                                                             TimW |
//|                                                             none |
//+------------------------------------------------------------------+
#property copyright "TimW"
#property link      "none"
#property version   "1.00"
#property strict
//--- input parameters
input double   TakeProfit=250.0;
input double   Lots=0.1;
input double   TrailingStop=35.0;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
  
  
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
int OnDeinit()
  {
   return(0);
  }
  

//|  My functions.......

int Crossed(double line1, double line2) 
   {
     static int last_direction = 0;
     static int current_direction = 0;
   
     if (line1 > line2) current_direction = 1; // up
     if (line1 < line2) current_direction = 2; // down
   
     if (current_direction != last_direction) //changed direction
     {
         last_direction = current_direction;
         return (last_direction);
   
     } 
     else 
     {
         return (0);
     }
}
    
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int OnTick()
  {
    int cnt, ticket, total;
    double shortEMA, longEMA;

    if(Bars>100)
    {
        Print("Bars less than 100");
        return(0);
    }
    if(TakeProfit>10)
    {
        Print("TakeProfit less than 10");
        return(0); // check TakeProfit...
    }
    
    shortEMA = iMA(NULL,0,8,0,MODE_EMA,PRICE_CLOSE,0);
    longEMA = iMA(NULL,0,13,0,MODE_EMA,PRICE_CLOSE,0);
    
    int isCrossed = Crossed (shortEMA, longEMA);
    total = OrdersTotal();
    
    
    
    if(total < 1)
    {
      if(isCrossed == 1)
         {
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"My-EA",12345,0,Green);
            if(ticket>0)
               {
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
               }
               else Print("Error opening BUY order : ",GetLastError());
               return(0);
               }
       if(isCrossed == 2)
         { ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,"My_EA",12345,0,Red);
            if(ticket>0)
               {
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))  Print("SELL order opened : ",OrderOpenPrice());
               }
               else Print("Error opening SELL order : ",GetLastError());
               return(0);
               }
               return(0);
    }
         
         
         for(cnt=0;cnt<total;cnt++)
            {
            OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
               if(OrderType()<=OP_SELL && ORDER_SYMBOL == Symbol())
               {
                  if(OrderType() == OP_BUY) // long position is opened
                  {
                  // should it be closed?
                     if(isCrossed == 2)
                     {
                     OrderClose(OrderTicket(),OrderLots(),Bid,3,clrViolet);  // close position
                     return(0);  // exit
                     }
                        if(TrailingStop>0)  // check for trailing stop
                           {
                           if(Bid-OrderOpenPrice() > Point*TrailingStop)
                              {
                              if(OrderStopLoss() < Bid - Point*TrailingStop)
                                 {
                                 OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green);
                                 return(0);
                                 }
                              }
                           }
                   }
                   else  // go to short position
                   {
                   // should it be closed?
                   if(isCrossed == 1)
                     {
                     OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);  // close position
                     return(0);  // exit
                     }
                        if(TrailingStop>0)  // check for Trailing stop
                           {
                           if(OrderOpenPrice()-Ask>(Point*TrailingStop))
                              {
                              if((OrderStopLoss()>Ask+(Point*TrailingStop)) || (OrderStopLoss() == 0))
                                 {
                                 OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red);
                                 return(0);
                                 }
                              }
                           }
                    }
               }
              
           }
           return(0);
   }
   
                     
                                 
            

//+------------------------------------------------------------------+
