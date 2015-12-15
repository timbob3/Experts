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

//                      Grid box entry - averaging in...




extern int PeriodX = 10;
extern int Limit = 1000;
extern int Stage1 = 100;

extern int Grid = 300;
extern int Amount = 300;

extern int LockDown = 0;
int Slippage = 50;

extern double TakeProfit = 180;
extern double StopLoss = 150;
extern double TrailingStop = 0;

input int    MovingPeriod  =25;
input int    MovingShift1  = 0;
input int    MovingShift2  = 0;
input int    TimeFrameMa1  = 0;

input int    MovingPeriod3  =50;
input int    MovingShift3  = 0;
input int    MovingShift4  = 2;
input int    TimeFrameMa3  = 0;

input int    StochLevelBuy   =30;
input int    StochLevelSell  =30;
input int    TimeFrameStoch1 =15;
input int    TimeFrameStoch3 =60;





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
  
  //ma1 & ma2 used for crossed over calculations
  double ma1=iMA(NULL,TimeFrameMa1,MovingPeriod,MovingShift1,MODE_LWMA,PRICE_CLOSE,0);
  double ma2=iMA(NULL,TimeFrameMa1,MovingPeriod,MovingShift2,MODE_SMA,PRICE_CLOSE,0);
  
  double ma3=iMA(NULL,TimeFrameMa3,MovingPeriod3,MovingShift3,MODE_SMA,PRICE_CLOSE,0);
  double ma4=iMA(NULL,TimeFrameMa3,MovingPeriod3,MovingShift4,MODE_SMA,PRICE_CLOSE,0);
  
  
  double Stoch1 = iStochastic(NULL, TimeFrameStoch1, 10, 6, 6, MODE_SMA, 0, MODE_MAIN, 0);
  double Stoch2 = iStochastic(NULL, TimeFrameStoch1, 10, 6, 6, MODE_SMA, 0, MODE_SIGNAL,0);
  double Stoch3 = iStochastic(NULL, TimeFrameStoch3, 10, 6, 6, MODE_SMA, 0, MODE_MAIN, 0);
  double Stoch4 = iStochastic(NULL, TimeFrameStoch3, 10, 6, 6, MODE_SMA, 0, MODE_SIGNAL,0);
  
  
  //+------------------------------------------------------------------+
//| Check for crossing of moving averages                                  |
//+------------------------------------------------------------------+  
  
  
   
  int isCrossed = Crossed(ma1,ma2);
  
  Comment("isCrossed value is :",isCrossed,"\n ma3 is :",ma3);
  
  //--- go trading only for first tiks of new bar
  if(Volume[0]>1) return;
   
      //BUY ORDER ***   Low[1]>Low[2] && Bid>High[1]
  if(isCrossed == 1 && ma3>ma4)  
    {         
     OrderSend(Symbol(),OP_BUY,Lots,Ask,1,Bid-StopLoss*Point,0,"",MAGICMA,0,clrAzure);
     
     // code for martyngale system
     //for(int i=1; i<4; i++){OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-i*Grid*Point,1,0,0,"",MAGICMA,0,clrAzure);}    
     //for(int k=1; k<4; k++){OrderSend(Symbol(),OP_SELLLIMIT,Lots,Bid+k*Grid*Point,1,0,0,"",MAGICMA,0,clrAzure);} 
     
     //code for non martyngale sys - 
     //for(int i=0; i<4; i++){OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-i*Grid*Point,1,Bid-StopLoss*Point,0,"",MAGICMA,0,clrAzure);}
  //for(int i=0; i<4; i++){OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-i*Grid*Point,1,(Bid-i*Grid*Point)-StopLoss*Point,(Bid-i*Grid*Point)+TakeProfit*Point,"",MAGICMA,0,clrAzure);} // try giving each individual buy its own SL and TP.
     // other variations...
     
     //for(int m=1; m<4; m++){OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-m*Grid*Point,1,Bid-StopLoss*Point,0,"",MAGICMA,0,clrAzure);}    
     //for(int k=1; k<4; k++){OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-k*Grid*Point,1,0,0,"",MAGICMA,0,clrAzure);}   
    }
    
     // SELL ORDER****  (High[1]-L>Limit*Point) && High[1]<High[2] && Bid<Low[1])
  if(isCrossed == 2 && ma3<ma4)
    {
    OrderSend(Symbol(),OP_SELL,Lots,Bid,1,Ask+StopLoss*Point,0,"",MAGICMA,0,clrAntiqueWhite);
  //   for(int j=1; j<3; j++){OrderSend(Symbol(),OP_SELLLIMIT,MathPow(2,j)*Lots,Bid+j*Grid*Point,1,Ask+StopLoss*Point,0,"",MAGICMA,0,CLR_NONE);}
    }
    
}  
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
int CheckForClose()
{

  //ma1 & ma2 used for crossed over calculations
  double ma1=iMA(NULL,TimeFrameMa1,MovingPeriod,MovingShift1,MODE_LWMA,PRICE_CLOSE,0);
  double ma2=iMA(NULL,TimeFrameMa1,MovingPeriod,MovingShift2,MODE_SMA,PRICE_CLOSE,0);
  
  int isCrossed = Crossed(ma1,ma2);
  
   //for(int iPos = OrdersTotal()-1; iPos >= 0; iPos--)
   //{
   //   if(OrderSelect(iPos,SELECT_BY_POS,MODE_TRADES) &&
   //   OrderSymbol()==Symbol() &&
   //   OrderMagicNumber()==MAGICMA)
   //   {
   //   //int Duration = TimeCurrent() - OrderOpenTime();
   //   //if(Duration < 1*24*3600) continue;
   //      if(High[1]<High[2] && Ask<Low[1])
   //      {
   //      CloseAll();
   //      }
   //   }
   //}
   



  //if(Amount>0 && getProfit()>=Amount)
  // {
  // CloseAll();
  // }
   
   //if(getProfit()<=-120)
   //   {
   //   CloseAll();
   //   }
    

for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        
        {
         if(OrderType()==OP_BUY)
           {
            if(isCrossed == 2)
              {
               OrderClose(OrderTicket(),OrderLots(),Bid,0,Violet); return(0);
              }
            if(TrailingStop>0)
              {
               if(Bid-OrderOpenPrice()>Point*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-Point*TrailingStop)  // the bit that stops modifying once the price slips back..
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green); return(0);
                    }
                 }
              }
           }
         if(OrderType()==OP_SELL)
           {
            if(isCrossed == 1)
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
         {Result=OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, clrBlue);}
         if(Pos==OP_SELL)
         {Result=OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, clrBlue);}
         if((Pos==OP_BUYSTOP)||(Pos==OP_SELLSTOP)||(Pos==OP_BUYLIMIT)||(Pos==OP_SELLLIMIT))
         {Result=OrderDelete(OrderTicket(), clrRed);}
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

int Crossed(double ma1, double ma2)
   {
   static int lastDirection    = 0;
   static int currentDirection = 0;
   
   if(ma1>ma2) currentDirection = 1; // going up
   if(ma1<ma2) currentDirection = 2; // going down
   
   if(currentDirection != lastDirection) // lines have crossed
      {
      lastDirection = currentDirection;
      return(lastDirection);
      } 
      else 
      {
      return(0);
      }
   }
 
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------