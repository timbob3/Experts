//+------------------------------------------------------------------+
//|                                                                  |
//|                               Copyright 2015, tj.weston@live.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, tj.weston@live.com"
#property link      "none"
#property version   "5.00"
#property strict


//+------------------------------------------------------------------+
//|   Based on built in Moving Average example                       |
//+------------------------------------------------------------------+

//                    CHANGE LOG **************


//          3 Dec 15  -  after first 2 trades both winning after 2 days in market!  Clean up code and a lot more back testing done.
//                    1/ - Comment given more info and moved to inside start() function.
//                    2/ - 


//--- Inputs

#define MAGICMA  3005621
input double PercentRisk   = 0.5;
input double ManualLots    = 0.0;
input int    StopLoss      = 30;
input int    TakeProfit    = 550;
input int    TrailingStop  = 325;
input int    DistFromMA    = 18;
input int    PeriodMA1     = 60;



//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//--- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
  } 
  
  
double LastTradeClose()
   {
    for(int x=OrdersHistoryTotal()-1; x>=0; x--)
      {
       if(!OrderSelect(x,SELECT_BY_POS,MODE_HISTORY)) break;
       if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         
        
        }
      
      }
   return(0);
   }
  
  
  

void CheckForOpen()          // ************  ENTRY  ***********************

  {
   double Ma1 = iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_CLOSE,0);
   double CalculatedLots = CalcLotSize(PercentRisk, StopLoss);
   static bool BoughtAlready;
   static bool SoldAlready;
   int res;   
                   
   //if(Volume[0]>1) return;  //--- go trading only for first tiks of new bar   
  
//--- buy conditions
   if(BoughtAlready==false && PipsFromMA1()>DistFromMA && Bid<Ma1 && Bid>High[1])//Bid<ma && ma-Bid>DistFromMA*Point)//) Crossed()==1 && 
     {
      res=OrderSend(Symbol(),OP_BUY,CalculatedLots,Ask,3,Bid-StopLoss*Point,Bid+TakeProfit*Point,"R300-v5-F2-1-BUY",MAGICMA,0,Blue);
      BoughtAlready = true;
      SoldAlready = false;
      return;
     }  
   
//--- sell conditions
   if(SoldAlready==false && PipsFromMA1()>DistFromMA && Bid>Ma1 && Ask<Low[1])//Bid>ma && Bid-ma>DistFromMA*Point)//) Crossed()==2 && 
     {
      res=OrderSend(Symbol(),OP_SELL,CalculatedLots,Bid,3,Ask+StopLoss*Point,Ask-TakeProfit*Point,"R300-v5-F2-1-SELL",MAGICMA,0,Red);
      SoldAlready = true;
      BoughtAlready = false;
      return;
     }
  }

void CheckForClose()  //   **********  EXIT   *******************************************

  {
   double Ma1 = iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_CLOSE,0);

    for(int cntS=0;cntS<OrdersTotal();cntS++)
    {
      OrderSelect(cntS, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)  
          
        {
         if(OrderType()==OP_BUY)  //  *** CLOSE BUY ***
           {
            if(TrailingStop>0)// && newbar==true) // && Bid-OrderOpenPrice()>Point*minMove
              {
               //if(Bid-OrderOpenPrice()>Point*TrailingStop)
               //  {
                  if(OrderStopLoss()<Bid-TrailingStop*Point)  // the bit that stops modifying once the price slips back..
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),(Bid-TrailingStop*Point),OrderTakeProfit(),0,White); 
                    // return(0);
                    }
                 //if(SarStop1<Open[1] && SarStop0>Open[0]) OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, clrBlue);
                 
               }
              
           }
         if(OrderType()==OP_SELL)  //  *** CLOSE SELL ***
           {
            if(TrailingStop>0)// && newbar==true)  //&& OrderOpenPrice()-Ask>Point*minMove
               //if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
               //  {
                  if(OrderStopLoss()>Ask+TrailingStop*Point)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),(Ask+TrailingStop*Point),OrderTakeProfit(),0,White); 
                    // return(0);
                    }
                  //if(Bid>SarStop()) OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, clrBlue);                                  
           }
         }       
    }  
 }



  
  
double PipsFromMA1()
   {
   double Ma1 = iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_CLOSE,0);
   double dist = NormalizeDouble((Bid-Ma1)/(Point*10),1);     
   if(dist<0) dist = -dist;
   return(dist);
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



void OnTick()  //   **** ON TICK FUNCTION ***
  {
//--- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false)
      return;
//--- calculate open orders by current symbol
   if(CalculateCurrentOrders(Symbol())==0) CheckForOpen();
   else                                    CheckForClose();

double CalculatedLots = CalcLotSize(PercentRisk,StopLoss);

     Comment("FX Acc Server:",AccountServer(),"\n",
           "Date: ",Month(),"-",Day(),"-",Year()," Server Time: ",Hour(),":",Minute(),":",Seconds(),"\n",
           "Symbol: ", Symbol(),"\n",
           "Pip Spread:  ",MarketInfo(Symbol(),MODE_SPREAD),"\n",
           "PercentRisk = ",PercentRisk,"\n"
           "DistFromMA = ",DistFromMA,"\n"
           "PipsFromMA1 ",PipsFromMA1(), "\n"
           "StopLoss ",StopLoss,"\n"
           "TrailingStop ",TrailingStop,"\n"
           "TakeProfit ",TakeProfit,"\n"
           "PeriodMA1 ",PeriodMA1,"\n" ); 

  }  //  *** END ON TICK ***










//               .................not used ...........................



//double LotsOptimized()
//  {
//   double lot=Lots;
//   int    orders=HistoryTotal();     // history orders total
//   int    losses=0;                  // number of losses orders without a break
////--- select lot size
//   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
////--- calcuulate number of losses orders without a break
//   if(DecreaseFactor>0)
//     {
//      for(int i=orders-1;i>=0;i--)
//        {
//         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
//           {
//            Print("Error in history!");
//            break;
//           }
//         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL)
//            continue;
//         //---
//         if(OrderProfit()>0) break;
//         if(OrderProfit()<0) losses++;
//        }
//      if(losses>1)
//         lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
//     }
////--- return lot size
//   if(lot<0.1) lot=0.1;
//   return(lot);
//  }
  
  

     //for(int i=0;i<OrdersTotal();i++)
   //  {
   //   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
   //   if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
   //   //--- check order type 
   //   if(OrderType()==OP_BUY)
   //     {
   //      if(Close[1]<Ma1 && Close[1]<Ma2)
   //        {
   //         if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,White))
   //            Print("OrderClose error ",GetLastError());
   //        }
   //      break;
   //     }
   //   if(OrderType()==OP_SELL)
   //     {
   //      if(Close[1]>Ma1 && Close[1]>Ma2)
   //        {
   //         if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,White))
   //            Print("OrderClose error ",GetLastError());
   //        }
   //      break;
   //     }
   //  }
//---
  
  //  int Crossed()
//   {
//   
//   double Ma1 = iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_CLOSE,0);
//   double Ma2 = iMA(NULL,0,PeriodMA2,0,MODE_SMA,PRICE_CLOSE,0);
//   
//    int Last_Direction;
//    int Current_Direction;
//   
//   if (Ma1>Ma2) Current_Direction = 1; // up
//   if (Ma1<Ma2) Current_Direction = 2; // down
//   
//   if (Current_Direction != Last_Direction) // direction has changed
//      {
//      Last_Direction = Current_Direction;
//      return (Last_Direction);
//      }
//   else
//      {
//      return (0);
//      }
//   }

  // double ma;
//--- go trading only for first tiks of new bar
 //  if(Volume[0]>1) return;
//--- get Moving Average 
 //  ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0);
//---

//input double MaximumRisk   =0.02;
//input double DecreaseFactor=3;
//input int    PeriodATR     = 200;
//input int    DistFromMaMax =250;
//input int    MovingPeriod  =9;
//input int    MovingShift   =0;
//input int    PeriodMA2     =40;
//double CalcLotSize();


//void CheckForClose()  //   **********  EXIT   modified quickly raising stop to breakeven... *******************************************
//
//  {
//   double Ma1 = iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_CLOSE,0);
//
//    for(int cntS=0;cntS<OrdersTotal();cntS++)
//    {
//      OrderSelect(cntS, SELECT_BY_POS, MODE_TRADES);
//      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)            
//        {
//        
//       if(OrderType()==OP_BUY)  //  *** CLOSE BUY ***
//           {
//            if(TrailingStop>0)// && newbar==true) // && Bid-OrderOpenPrice()>Point*minMove
//              {
//               if(Bid-OrderOpenPrice()>Point*StopLoss/2 && Bid-OrderOpenPrice()<Point*StopLoss)
//                 {
//                  OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,White);
//                 }
//               if(Bid-OrderOpenPrice()>Point*StopLoss)
//                 {     
//                  if(OrderStopLoss()<Bid-TrailingStop*Point)  // the bit that stops modifying once the price slips back..
//                    {
//                     OrderModify(OrderTicket(),OrderOpenPrice(),(Bid-TrailingStop*Point),OrderTakeProfit(),0,White); 
//                    // return(0);
//                    }
//                  }                 
//                }
//              
//           }
//           
//       if(OrderType()==OP_SELL)  //  *** CLOSE SELL ***
//           {
//            if(TrailingStop>0)// && newbar==true) // && Bid-OrderOpenPrice()>Point*minMove
//              {
//               if(OrderOpenPrice()-Ask>Point*StopLoss/2 && OrderOpenPrice()-Ask<Point*StopLoss)
//                 {
//                  OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,White);
//                 }
//               if(OrderOpenPrice()-Ask>Point*StopLoss)
//                 {     
//                  if(OrderStopLoss()>Ask+TrailingStop*Point)  // the bit that stops modifying once the price slips back..
//                    {
//                     OrderModify(OrderTicket(),OrderOpenPrice(),(Ask+TrailingStop*Point),OrderTakeProfit(),0,White);
//                    }
//                  }                 
//                }
//              
//           }  
//         }       
//    }  
// }