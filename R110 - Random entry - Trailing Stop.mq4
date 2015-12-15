//+------------------------------------------------------------------+
//|                                                  TimeBasedEA.mq4 |
//|                      Copyright © 2008, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
//changed by:       "forex4capital@yahoo.ca"

// Time frame: M5 and higher

extern int     MagicNumber = 104;
extern double  TakeProfit  = 20000;
extern double  TrailingStop = 300;
extern double  StopLoss    = 300;
extern double  minMove     = 600;

extern double  TimeFrameA     =0;
extern double  StochLevelBuy  = 30;
extern double  StochLevelSell  = 70;

extern double  TimeFrameB        =0;
extern double  StochLevelBuyB  = 30;
extern double  StochLevelSellB  = 70;
extern double  KPeriod        = 5;
extern double  KPeriodB       =5;
extern double  DPeriod        =12;
extern double  Slowing        =12;

extern double  ma1Period       =25;
extern double  ma2Period       =300;

extern double  Lots        = 0.1;
extern int     StartHour   = 0900;      // Open Trade time
extern bool    OpenBuy     = true;
extern bool    OpenSell    = false;
extern int     NumBuys     = 1;
extern int     NumSells    = 1;
extern int     Slippage    = 2;

//+------------------------------------------------------------------+
//|                        S T A R T                                 |
//+------------------------------------------------------------------+
int start()
  {
   int cnt, ticket, total;
   int ct;
//-------------------------------------+
   if(Bars<100)
     {
      Print("bars less than 100");
      return(0);  
     }
//-------------------------------------+
   if(TakeProfit<10)
     {
      Print("TakeProfit less than 10");
      return(0);  // check TakeProfit
     }
//-------------------------------------+
   ct = Hour() * 100 + Minute();
   total=OrdersTotal();
   
//   double Stoch1 = iStochastic(NULL, TimeFrameA, KPeriod, KPeriod*0.6, KPeriod*0.6, MODE_SMA, 0, MODE_MAIN,0);
//   double Stoch2 = iStochastic(NULL, 0, KPeriod, KPeriod*0.6, KPeriod*0.6, MODE_SMA, 0, MODE_SIGNAL,2);
//   double Stoch3 = iStochastic(NULL, TimeFrameB, KPeriodB, KPeriodB*0.6, KPeriodB*0.6, MODE_SMA, 0, MODE_SIGNAL,3);
//   double Stoch4 = iStochastic(NULL, 0, KPeriodB, KPeriodB*0.6, KPeriodB*0.6, MODE_SMA, 0, MODE_SIGNAL,5);   
//
//   double ma1=iMA(NULL,0,ma1Period,0,MODE_SMA,PRICE_CLOSE,0);
//   double ma2=iMA(NULL,0,ma2Period,0,MODE_SMA,PRICE_CLOSE,0);

//  **** ENTRY ****
 
   if(total<1) 
     {
      // no opened orders identified
      if(AccountFreeMargin()<(1000*Lots))
        {
         Print("We have no money. Free Margin = ", AccountFreeMargin());
         return(0);  
        }
        
      //check for long position (BUY) possibility((*******
      if(ct == StartHour && OpenBuy)
      //if(  Stoch3<StochLevelBuyB && ma1>ma2 && OpenBuy)
      //if(ct == StartHour && High[1]<Open[0] && OpenBuy)
        {
         for ( cnt = 0; cnt < NumBuys; cnt++)
         {
           ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Bid-StopLoss*Point,Ask+TakeProfit*Point,"",MagicNumber,0,Blue);
           if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
           }
           else Print("Error opening BUY order : ",GetLastError()); 
         }
         return(0); 
        }
        
      // check for short position (SELL) possibility *****
      //ct == StartHour &&  Stoch1>StochLevelSell &&  && High[1]<High[2] && High[2]>High[3]
      //if(  Stoch3>StochLevelSellB && ma1<ma2 && OpenSell)
      if(ct == StartHour && OpenSell)
      //if(ct == StartHour && Low[1]>Open[0] && OpenSell)
        {
         for ( cnt = 0; cnt < NumSells; cnt++)
         {
           ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Ask+StopLoss*Point,Bid-TakeProfit*Point,"",MagicNumber,0,Red);
           if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
           }
           else Print("Error opening SELL order : ",GetLastError());
         } 
         return(0); 
        }
     } 
     
     
     // **** EXIT *****
     
     for(int cntS=0;cntS<OrdersTotal();cntS++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==104)
        
        {
         if(OrderType()==OP_BUY)
           {
//            if(isCrossed == 2)
//              {
//               OrderClose(OrderTicket(),OrderLots(),Bid,0,Violet); return(0);
//              }
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
//            if(isCrossed == 1)
//              {
//               OrderClose(OrderTicket(),OrderLots(),Ask,0,Violet); return(0);            
//              }
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
  }
// the end.