//+------------------------------------------------------------------+
//|                                       TimMartingaleSystem-V0.mq4 |
//|                                      Copyright 2015, Tim Weston. |
//|                                                      https://www |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Tim Weston"
#property link      "https://www"
#property version   "1.00"
#define MAGICMA  100

// ********************OPTIMISED FOR EURUSD 15M CHART ***************************************
//                     1/  Possible to Disable selling for an "Amount" by setting Amount to zero
//                     2/  Try using stop loss, below grid to avoid catastrophy.
//                     3/  Use trailing stop ??
//                     4/  try using MA to time entries to the trend

//                    ** Good base code - for buying in martingale style - with stops that work **


extern int PeriodX = 60;
extern int Limit = 800;

extern int Grid = 10;
extern int Amount = 10;

extern int LockDown = 0;
int Slippage = 50;

extern double StopLoss = 400;
extern double TrailingStop = 0;

input int    MovingPeriod  =50;
input int    MovingPeriod3  =50;


input int    MovingShift1  =0;
input int    MovingShift2  =2;
input int    MovingShift3  =0;
input int    MovingShift4  =2;

input int   StochLevelBuy  =20;
input int   StochLevelSell =80;


//+------------------------------------------------------------------+
//| Start function                                                   |
//+------------------------------------------------------------------+
void start()
  {
//---- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false) return;
//---- calculate open orders by current symbol
   if(OrdersTotal()==0) CheckForOpen();
   else CheckForClose();
//----
   
  }
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
int CheckForOpen()
{
  double L = Low[iLowest(NULL,0,MODE_LOW,PeriodX,0)];
  double H = High[iHighest(NULL,0,MODE_HIGH,PeriodX,0)];
  double Lots = MathRound(AccountBalance()/100)/1000;
  
  double ma1=iMA(NULL,0,MovingPeriod,MovingShift1,MODE_SMA,PRICE_CLOSE,0);
  double ma2=iMA(NULL,0,MovingPeriod,MovingShift2,MODE_SMA,PRICE_CLOSE,0);
  double ma3=iMA(NULL,0,MovingPeriod3,MovingShift3,MODE_SMA,PRICE_CLOSE,0);
  double ma4=iMA(NULL,0,MovingPeriod3,MovingShift4,MODE_SMA,PRICE_CLOSE,0);
  
  double Stoch1 = iStochastic(NULL, PERIOD_D1, 21, 7, 3, MODE_SMA, 0, MODE_SIGNAL, 0);
  double Stoch2 = iStochastic(NULL, PERIOD_D1, 21, 7, 3, MODE_SMA, 0, MODE_SIGNAL, 2);
  
  if((H-Bid>Limit*Point) && ma1>ma2)
    {OrderSend(Symbol(),OP_BUY,Lots,Ask,1,Bid-StopLoss*Point,0,"",MAGICMA,0,CLR_NONE);
     for(int i=1; i<3; i++){OrderSend(Symbol(),OP_BUYLIMIT,MathPow(2,i)*Lots,Ask-i*Grid*Point,1,Bid-StopLoss*Point,0,"",MAGICMA,0,CLR_NONE);}
    Comment("Pointsize is: ", Point()); 
    }
    
    
  if((Bid-L>Limit*Point) && ma1<ma2)
    {OrderSend(Symbol(),OP_SELL,Lots,Bid,1,Ask+StopLoss*Point,0,"",MAGICMA,0,CLR_NONE);
     for(int j=1; j<3; j++){OrderSend(Symbol(),OP_SELLLIMIT,MathPow(2,j)*Lots,Bid+j*Grid*Point,1,Ask+StopLoss*Point,0,"",MAGICMA,0,CLR_NONE);}
    }
    
}  
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
int CheckForClose()
{
  if(Amount>0 && getProfit()>=Amount){CloseAll();}
    

for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        
        {
         if(OrderType()==OP_BUY)
           {
            if(OrderOpenPrice()-Ask>StopLoss*Point)
              {
               OrderClose(OrderTicket(),OrderLots(),Bid,0,Violet); return(0);
              }
            if(TrailingStop>0)
              {
               if(Bid-OrderOpenPrice()>Point*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-Point*TrailingStop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green); return(0);
                    }
                 }
              }
           }
         if(OrderType()==OP_SELL)
           {
            if(Bid-OrderOpenPrice()>StopLoss*Point)
              {
               OrderClose(OrderTicket(),OrderLots(),Ask,0,Violet); return(0);
              }
            if(TrailingStop>0)
              {
               if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red); return(0);
                    }
                 }
              }
           }
         }
       }
  

}  
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
double getProfit()
{
   double Profit = 0;
   for (int TradeNumber = OrdersTotal(); TradeNumber >= 0; TradeNumber--)
   {
     if (OrderSelect(TradeNumber, SELECT_BY_POS, MODE_TRADES))
     Profit = Profit + OrderProfit() + OrderSwap();
   }
   return (Profit);
}
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
void CloseAll()
{
   bool   Result;
   int    i,Pos,Error;
   int    Total=OrdersTotal();
   
   if(Total>0)
   {
     for(i=Total-1; i>=0; i--) 
     {
       if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
       {
         Pos=OrderType();
         if(Pos==OP_BUY)
         {Result=OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, CLR_NONE);}
         if(Pos==OP_SELL)
         {Result=OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, CLR_NONE);}
         if((Pos==OP_BUYSTOP)||(Pos==OP_SELLSTOP)||(Pos==OP_BUYLIMIT)||(Pos==OP_SELLLIMIT))
         {Result=OrderDelete(OrderTicket(), CLR_NONE);}
//-----------------------
         if(Result!=true) 
          { 
             Error=GetLastError(); 
             Print("LastError = ",Error); 
          }
         else Error=0;
//-----------------------
       }   
     }
   }
   return(0);
}
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------