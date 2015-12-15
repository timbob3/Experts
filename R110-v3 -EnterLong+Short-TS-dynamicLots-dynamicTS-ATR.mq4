//+------------------------------------------------------------------+
//|                                                  TimeBasedEA.mq4 |
//|                      Copyright © 2008, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
//changed by:       "forex4capital@yahoo.ca"

// Time frame: M5 and higher

extern int     MagicNumber  = 1103;
extern double  TakeProfit   = 20000;
extern double  TrailingStop = 500;
extern double  StopLoss     = 800;
extern double  PercentRisk  = 1.0;
extern double  ManualLots   = 0;

extern int     StartHour    = 0900;      // Open Trade time
extern bool    OpenBuy      = true;
extern bool    OpenSell     = true;
extern int     Slippage     = 2;



//+------------------------------------------------------------------+
//|                        S T A R T                                 |
//+------------------------------------------------------------------+
int start()
  {
   int cnt, ticket, total;
   int ct;
   double Lots = CalcLotSize(PercentRisk,StopLoss);
   
//-------------------------------------+
   if(Bars<100)
     {
      Print("bars less than 100");
      return(0);  
     }

   ct = Hour() * 100 + Minute();
   total=OrdersTotal();


//  **** ENTRY ****
 
   if(total<1) // no opened orders identified
     {
      if(AccountFreeMargin()<(1000*Lots))
        {
         Print("We have no money. Free Margin = ", AccountFreeMargin());
         return(0);  
        }
        
      if(ct == StartHour)
        {
           ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Bid-StopLoss*Point,Ask+TakeProfit*Point,"",MagicNumber,0,Blue);
           if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
           }
           else Print("Error opening BUY order : ",GetLastError()); 
         
         
           ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Ask+StopLoss*Point,Bid-TakeProfit*Point,"",MagicNumber,0,Red);
           if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
           }
           else Print("Error opening SELL order : ",GetLastError());
        
         return(0); 
        }
     } 
     
     
     // **** check for EXITs *****
     
     for(int cntS=0;cntS<OrdersTotal();cntS++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        
        {
         if(OrderType()==OP_BUY)
           {
            if(TrailingStop>0) // && Bid-OrderOpenPrice()>Point*minMove
              {
               if(Bid-OrderOpenPrice()>Point*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-Point*TrailingStop)  // the bit that stops modifying once the price slips back..
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,White); return(0);
                    }
                 }
              }
           }
         if(OrderType()==OP_SELL)
           {
            if(TrailingStop>0 )  //&& OrderOpenPrice()-Ask>Point*minMove
              {
               if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,White); return(0);
                    }
                 }
              }
           }
         }
       }
     
   return(0);
 
 
}  // *** end start function ***

double CalcLotSize(double PercentRisk,double StopLoss)
   {
   double Lots;    // calculated Lot size for order
   double MinLot;  // broker minimum lot size
   double LotStep; // broker minimum lot step
   double MaxLot;  // broker maximum lot step
   double LotSize; // Value in currency of 1.0 Lot
   
   MinLot  = MarketInfo(Symbol(),MODE_MINLOT);
   LotStep = MarketInfo(Symbol(),MODE_LOTSTEP);
   MaxLot  = MarketInfo(Symbol(),MODE_MAXLOT);
   LotSize = MarketInfo(Symbol(),MODE_LOTSIZE);
    
   if(ManualLots > 0.0) {Lots = ManualLots;}  // Use the size input by the user
   else { // calculate auto lot size
       
   Lots = (AccountEquity()*PercentRisk/100) / (StopLoss*Point*LotSize);
   
   if(Lots < MinLot) {Lots = MinLot;}//Broker's absolute minimum Lot
   if(Lots > MaxLot) {Lots = MaxLot;}//Broker's absolute maximum Lot
        } 
   return(Lots);
   }
   
 