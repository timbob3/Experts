//+------------------------------------------------------------------+
//|                                                       105-v4.mq4 |
//|                               Copyright 2015, tj.weston@live.com |
//|                                                      https://www |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, tj.weston@live.com"
#property link      "https://www"
#property version   "1.00"
#property strict


extern double Amount = 3; // Amount of profit in dollars - before closeAll order is sent
extern int MagicN = 0000;
extern int TakeProfit = 100;
extern int StopLoss   = 200;
extern double TrailingStop = 10;

extern double lot1   =  0.1;
extern double lot2   =  0.15;
extern double lot3   =  0.2;
extern double lot4   =  0.25;
extern double lot5   =  0.2;
extern double lot6   =  0.2;
extern double lot7   =  0.2;
extern double lot8   =  0.2;
extern double lot9   =  0.2;
extern double lot10  =  0.2;
extern double lot11  =  0.2;
//extern int opentime = 4 ;
//extern int closetime = 13;

 
extern int opentime = 16;
extern bool canTrade = true;
int Slippage = 50;
 
//--- global variable

//double MasterUpperLevel =0;
//double MasterLowerLevel =0;


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
  
 
  //int j=0;
  // int hourtime= TimeHour(Time[j]);
 //Comment("TimeHour() = ",hourtime);
//---


int total = OrdersTotal();

int i;
double OpenLongOrders = 0, OpenShortOrders = 0, PendLongs =0, PendShorts =0;


//
if(canTrade == true )//hourtime==opentime )
{

if(total == 0 && OpenLongOrders == 0 && OpenShortOrders == 0 && PendLongs == 0 && PendShorts == 0)
      {
             openbuy();
             sellstop();
      }
}


//
 for( i=total-1;i>=0;i--)       
   {
     OrderSelect(i, SELECT_BY_POS );
    if ( OrderSymbol() == Symbol() && OrderMagicNumber() == MagicN)
         {
           int type = OrderType();

if (type == OP_BUY )       {OpenLongOrders=OpenLongOrders+1;}
if (type == OP_SELL )      {OpenShortOrders=OpenShortOrders+1;}
if (type == OP_BUYSTOP )   {PendLongs=PendLongs+1;}
if (type == OP_SELLSTOP )  {PendShorts=PendShorts+1;}
  
double myAccount = AccountBalance();  
  
Comment("Open Orders = ",total,"\nopenlongOrders = ",OpenLongOrders," \nopenShortOrders = ",
OpenShortOrders,"\nPendLongs = ",PendLongs,
"\nPendShorts = ",PendShorts,
"\nProfit = ", getProfit(),
"\nAccount Balance = ",myAccount);  
  
  
  if(total == 1 && OpenLongOrders == 0 && OpenShortOrders == 1 && PendLongs == 0 && PendShorts == 0)
      {
             buystop();
      }
    if(total == 1 && OpenLongOrders == 1 && OpenShortOrders == 0 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop1();
      }  
            if(total == 1 && OpenLongOrders == 0 && OpenShortOrders == 0 && (PendLongs == 1 || PendShorts == 1))
      {
             deleteallpendingorders();
      }
       
      //Sleep(2000);
      }
   } 
   
   CheckForClose();


} // end of "onTick" function
  
  
  
  
//+------------------------------------------------------------------+
void openbuy()
{
 OrderSend(Symbol(),OP_BUY,lot1,Ask,3,Ask-StopLoss*Point,Bid+TakeProfit*Point,NULL,MagicN,0,clrBlue);
}

void sellstop()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot2,Ask-StopLoss*Point,3,Ask,0,NULL,MagicN,0,clrBlue);  //((Ask-StopLoss*Point)+(Ask-TakeProfit*Point))
}




void buystop()
{
 OrderSend(Symbol(),OP_BUYSTOP,lot3,Ask+StopLoss*Point,3,Ask,((Ask+StopLoss*Point)+(Ask+TakeProfit*Point)),NULL,MagicN,0,clrBlue);
}
void sellstop1()
{
 OrderSend(Symbol(),OP_SELLSTOP,lot4,Ask-StopLoss*Point,3,Ask,((Ask-StopLoss*Point)+(Ask-TakeProfit*Point)),NULL,MagicN,0,clrBlue);
}




//=========================================================
//
//=========================================================

void deleteallpendingorders()
{
   for(int i=0;i<OrdersTotal();i++)
   {
     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
     if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicN && ((OrderType()==OP_BUY) || (OrderType()==OP_SELL) ||(OrderType()==OP_BUYSTOP) || (OrderType()==OP_SELLSTOP) || (OrderType()==OP_BUYLIMIT) || (OrderType()==OP_SELLLIMIT)))
     {
       OrderDelete(OrderTicket());
     }   
   }
}


int CheckForClose()
{
  if(Amount>0 && getProfit()>=Amount)
   {
   CloseAll();
   }
   
   //if(getProfit()<=-120)
   //   {
   //   CloseAll();
   //   }
   return(0);
}

    
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
   //return(0); 
}


double getProfit()
{
   double Profit = 0;
   for (int TradeNumber = OrdersTotal(); TradeNumber >= 0; TradeNumber--)
   {
     if (OrderSelect(TradeNumber, SELECT_BY_POS, MODE_TRADES))
     Profit = Profit + OrderProfit() + OrderSwap() + OrderCommission();
   }
   return (Profit);
}
//
//int CheckForClose()
//{
//
//   //for(int iPos = OrdersTotal()-1; iPos >= 0; iPos--)
//   //{
//   //   if(OrderSelect(iPos,SELECT_BY_POS,MODE_TRADES) &&
//   //   OrderSymbol()==Symbol() &&
//   //   OrderMagicNumber()==MAGICMA)
//   //   {
//   //   int Duration = TimeCurrent() - OrderOpenTime();
//   //   if(Duration < 1*24*3600) continue;
//   //   CloseAll();
//   //   }
//   //}
//   
//
//
//
////  if(Amount>0 && getProfit()>=Amount)
////   {
////   CloseAll();
////   }
////   
////   if(getProfit()<=-120)
////      {
////      CloseAll();
////      }
//    
//
//for(int cnt=0;cnt<OrdersTotal();cnt++)
//     {
//      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
//      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicN)
//        
//        {
//         if(OrderType()==OP_BUY)
//           {
//            if(OrderOpenPrice()-Ask>StopLoss*Point)
//              {
//               OrderClose(OrderTicket(),OrderLots(),Bid,0,Violet); return(0);
//              }
//            if(TrailingStop>0)
//              {
//               if(Bid-OrderOpenPrice()>Point*TrailingStop)
//                 {
//                  if(OrderStopLoss()<Bid-Point*TrailingStop)  // the bit that stops modifying once the price slips back..
//                    {
//                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green); return(0);
//                    }
//                 }
//              }
//           }
//         if(OrderType()==OP_SELL)
//           {
//            if(Bid-OrderOpenPrice()>StopLoss*Point)
//              {
//               OrderClose(OrderTicket(),OrderLots(),Ask,0,Violet); return(0);
//              }
//            if(TrailingStop>0)
//              {
//               if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
//                 {
//                  if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
//                    {
//                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red); return(0);
//                    }
//                 }
//              }
//           }
//         }
//       }
//       }
//       
//       
  
