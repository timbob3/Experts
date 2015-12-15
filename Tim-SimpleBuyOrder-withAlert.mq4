//+------------------------------------------------------------------+
//|                                 Tim-SimpleBuyOrder-withAlert.mq4 |
//|                                                             TimW |
//|                                                             none |
//+------------------------------------------------------------------+
#property copyright "TimW"
#property link      "none"
#property version   "1.00"
#property strict

extern int TakeProfit = 10;
extern int StopLoss   = 10;
input double TrailingStop =15;
extern double Lots    = 0.1;

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
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double TakeProfitLevel;
   double StopLossLevel;
   double profit = OrderProfit();
   
   
   TakeProfitLevel = Bid+TakeProfit*Point;
   StopLossLevel   = Bid-StopLoss*Point;
   
   //OrderSend can return ticket no., or -1 if it failed to retrieve ticket no.
   int ticket;
   
   if(OrdersTotal()<=0)
   {
   
   profit = 0;
   
   ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,StopLossLevel,0,"I boughtit",0,0,Blue);
   
      if(ticket<0)
      {
      Alert("Error!");
      }
      
      //  Trailing stop
      
            if(OrderType()==OP_BUY)
         {
                  if(TrailingStop>0)  
              {                 
               if(Bid-OrderOpenPrice()>Point*TrailingStop)
                 {
                  //if(OrderStopLoss()<Bid-Point*TrailingStop)
                    //{
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green);
                     //return(0);
                    //}
                 }
              }
          }
      
   }
   
   Comment("Total order are : ",OrdersTotal() , "  Profit : ",profit);
   
  }
//+------------------------------------------------------------------+
