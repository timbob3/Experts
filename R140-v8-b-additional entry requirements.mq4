//+------------------------------------------------------------------+
//|                                                                  |
//|                                    Copyright © 2015, Tim Weston. |
//|                                                                  |
//+------------------------------------------------------------------+



// ----------------------------ENTRY - at a set minimum distand from MA.
// --------------------------  EXIT  - with normal-TrailingStops...
//---------------------
//                              Good results - using MA=700, SARStep=0.002, SL = 100, TP = 400, minDistancefromMA = 600.

          


extern int     MagicNumber  = 14082;
extern double  TakeProfit   = 20000;
extern double  TrailingStop = 500;
extern double  StopLoss     = 200;
extern double  SARStep      = 0.002;
extern int     SARTimePeriod = 60;  // Important, enter correct time period before trading
extern double  PercentRisk  = 1.0;
extern double  ManualLots   = 0;
extern double  XFactor      = 0.01;
extern int     ChannelLength = 25;
extern double  Limit        = 1000;
extern int     X            = 16;
extern double  PercentATR   = 0.8;
extern int     AtrTimeFrame = 3;
extern int     AtrStopMultiple = 3;
extern double  Drop         = 0.0050;
extern int     PeriodMA     = 280;
extern double  MinDistFromMa = 600; // distance away from MA to enter..

extern double  MaxDistFromMa = 300;
extern double  DistFromPrice = 300;
extern double  PriceSARfactor = 80;

//extern int     StochLevelH   = 80;
//extern int     StochLevelL   = 20;
extern double  PeriodMA1    =700;
extern double  PeriodMA2    =21;

//extern int     StartHour    = 0900;      // Open Trade time
extern bool    OpenBuy      = true;
extern bool    OpenSell     = true;
extern int     Slippage     = 2;

int oldTime;


//+------------------------------------------------------------------+
//|  deinitialization function                                 |
//+------------------------------------------------------------------+
int init()
  {
   oldTime = Time[0];
   return(0);
  }
//+------------------------------------------------------------------+
//|  deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }


//+------------------------------------------------------------------+
//|                        S T A R T                                 |
//+------------------------------------------------------------------+
int start()
{
   
   int cnt, ticket, total;
   int ct;
   double Lots = CalcLotSize(PercentRisk,StopLoss);
   static bool tradedThisBar;  // tried declaring this without the static - didn't work.  Needs static to keep it's value for duration of the bar..
   int OpenPositions =0, PendingPositions =0;
   
   
  
//Comment("Crossed= ",Crossed(),"\nTradedThisBar = ",tradedThisBar);   
//-------------------------------------+
   if(Bars<100)
     {
      Print("bars less than 100");
      return(0);  
     }

   ct = Hour() * 100 + Minute();
   total=OrdersTotal();
   
   
   double H = High[iHighest(NULL,0,MODE_HIGH,ChannelLength,1)];
   double L = Low[iLowest(NULL,0,MODE_LOW,ChannelLength,1)];
   double Channel = NormalizeDouble((H-L)/(Point*10),0);
   double PercentOfChannel = NormalizeDouble((Bid-L)/(H-L)*100,0);
   double THour = TimeHour(MarketInfo(Symbol(),MODE_TIME));
   double TMinute = TimeMinute(MarketInfo(Symbol(),MODE_TIME));

   double Ma1 = iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_CLOSE,0);
//   double Ma2 = iMA(NULL,0,PeriodMA2,0,MODE_SMA,PRICE_CLOSE,0);
   
   
   bool newbar;  // got this from mql.4 forum.  But added my bits ("tradedThisBar") above and below to make it work !!! :)
   if(Volume[0]==1)
   {
   newbar=true;
   tradedThisBar=false;
   }

Comment("ServerTime ",THour,":",TMinute,"\n"
        "Crossed = ",Crossed(),"\n"
        "in last ",ChannelLength," days","\n"
        "Channel width = ",Channel,"\n"
        "PercentOfChannel = ",PercentOfChannel,"\n"
        "PriceSARdiff = ",PriceSARdiff()); 

//  ------------------------------------- **** ENTRY ****  ----------------------------------------------------------------------------------------------

  
   
   if(total<1 && tradedThisBar==false) // no opened orders identified
   {
      if(AccountFreeMargin()<(1000*Lots))
        {
         Print("We have no money. Free Margin = ", AccountFreeMargin());
         return(0);  
        }  
        
//BUY***   
   if(Ma1-Bid>MinDistFromMa*Point && Bid>SarStop() && Close[1] >SarStop())//&& (Close[1]<SarStop() || Close[2]<SarStop() || Close[3]<SarStop()))// && tradedThisBar==false)
   {
           ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Bid-StopLoss*Point,0," R140-v8-b ",MagicNumber,0,Blue);
           if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
            tradedThisBar = true;
            Print("tradedThisBar = true - BUY");
           }
           else Print("Error opening BUY order : ",GetLastError()); 
   }
             
         
//SELL*****        
   if(Bid-Ma1>MinDistFromMa*Point && Bid<SarStop() && Close[1]<SarStop())// && tradedThisBar==false)
   {
           ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Ask+StopLoss*Point,0," R140-v8-b ",MagicNumber,0,Blue);
           if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
            tradedThisBar = true;
            Print("tradedThisBar = true - SELL");
           }
           else Print("Error opening BUY order : ",GetLastError()); 
   }
  
  }
        
            
// -----------------------------------**** check for EXITs *****==-------------------------------------------------------------------
     
     
   for(int cntS=0;cntS<OrdersTotal();cntS++)
    {
      OrderSelect(cntS, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)      
        {
         if(OrderType()==OP_BUY)
           {
            if(TrailingStop>0)// && newbar==true) // && Bid-OrderOpenPrice()>Point*minMove
              {
               //if(Bid-OrderOpenPrice()>Point*TrailingStop)
               //  {
                  if(OrderStopLoss()<(Bid-TrailingStop*Point))  // the bit that stops modifying once the price slips back..
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),(Bid-TrailingStop*Point),OrderTakeProfit(),0,White); 
                    // return(0);
                    }
                 // if(Bid<SarStop()) OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, clrBlue);
                 
               }
              
           }
         if(OrderType()==OP_SELL)
           {
            if(TrailingStop>0)// && newbar==true)  //&& OrderOpenPrice()-Ask>Point*minMove
               //if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
               //  {
                  if(OrderStopLoss()>(Ask+TrailingStop*Point))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),(Ask+TrailingStop*Point),OrderTakeProfit(),0,White); 
                    // return(0);
                    }
                //  if(Bid>SarStop()) OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, clrBlue);                                  
           }
         }
       
    }    
   return(0);
 
}  // *** end start function ***



//---------------------*** My Functions ***--------------------------------------------------------------------------------------------


int Crossed()
 {
    int Last_Direction;
    int Current_Direction;
   
   if (Bid>SarStop()) Current_Direction = 1; // up
   if (Bid<SarStop()) Current_Direction = 2; // down
   
   if (Current_Direction != Last_Direction) // direction has changed
      {
      Last_Direction = Current_Direction;
      return (Last_Direction);
      }
   else
      {
      return (0);
      }
 }


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
       
   Lots = NormalizeDouble((AccountEquity()*PercentRisk/100) / (StopLoss*Point*LotSize),2);
   
   if(Lots < MinLot) {Lots = MinLot;}//Broker's absolute minimum Lot
   if(Lots > MaxLot) {Lots = MaxLot;}//Broker's absolute maximum Lot
        } 
   return(Lots);
 }
  
  
  
double PriceSARdiff()
   {
   double diff = NormalizeDouble((Bid-SarStop())/(Point*10),0);  
   
   if(diff<0) diff = -diff;
   return(diff);
   }
  
   
double SarStop()
 {
   double ParaSAR = NormalizeDouble(iSAR(NULL,0,SARStep,0.2,0),5);
   return(ParaSAR);   
 } 
   
   
double AtrStop()
 {
   double Stop = NormalizeDouble(AtrStopMultiple * iATR(NULL,0,AtrTimeFrame,0),5);
   return(Stop);   
 }  
 
   
void DeletePendPositions()
   {
   for(int i=0;i<OrdersTotal();i++)
      {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) 
         {
         if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
            {
            OrderDelete(OrderTicket(),clrMagenta);
            }
         }
      }
   
   }   
   
   
bool isNewBar()  //  Using this to prevent modifying orders trailing stop too often, ie without any change..
 {
   static long last_time = 0;
   
   datetime lastbar_time = SeriesInfoInteger(Symbol(),0,SERIES_LASTBAR_DATE);
   
   if(last_time == 0)  // if it's the first call of the function..
   {
   last_time = lastbar_time;
   return(false);
   }
   
   if(last_time != lastbar_time)  // if time differs..
   {
   last_time = lastbar_time;
   return(true);
   }   
   return(false);  // if we passed to this line, then the bar is not new...   
 }
   
   
   
   
   
   
//   deleted stuff ******************
   
   //----test code   
   //if (newbar==true)
   // {
   //  newbar=false;
   // }
   
      //iATR(Null,0,3,0)  || (Low[1]>Low[2] && Low[2]<Low[3]))   Bid>High[1] &&  High[1]<High[2] && Low[1]>Low[2]  && (High[6]-Bid>Drop)
   // && Bid-Close[1]> (PercentATR*iATR(NULL,0,AtrTimeFrame,0))