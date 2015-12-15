//+------------------------------------------------------------------+
//|                                                       105-v4.mq4 |
//|                               Copyright 2015, tj.weston@live.com |
//|                                                      https://www |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, tj.weston@live.com"
#property link      "https://www"
#property version   "1.00"
#property strict


extern double Amount = 20; // Amount of profit in dollars - before closeAll order is sent
extern int MagicN = 0000;
extern int TakeProfit = 200;
extern int StopLoss   = 200;
extern double TrailingStop = 0;

extern double lot1   =  0.1;
extern double lot2   =  0.2;
extern double lot3   =  0.3;
extern double lot4   =  0.4;
extern double lot5   =  0.5;
extern double lot6   =  0.6;
extern double lot7   =  0.7;
extern double lot8   =  0.8;
extern double lot9   =  0.9;
extern double lot10  =  1.0;
extern double lot11  =  1.1;
extern double lot12  =  1.2;
extern double lot13  =  1.3;
extern double lot14  =  1.4;
extern double lot15  =  1.5;
extern double lot16  =  1.5;
extern double lot17  =  0.75;
//extern int opentime = 4 ;
//extern int closetime = 13;

 
//--- global variable 
extern int opentime = 16;
extern bool canTrade = true;
int Slippage = 50;
int ticket; 

int Tick =0;
double InitialPrice=0;


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
  
  Tick++;
  
//Comment("no. of ticks: ", Tick);
 return;
  //int j=0;
  // int hourtime= TimeHour(Time[j]);
 //Comment("TimeHour() = ",hourtime);
//---


int total = OrdersTotal();
int i;
double OpenLongOrders = 0, OpenShortOrders = 0, PendLongs =0, PendShorts =0;
double InitialPrice =0;
double Spread = 0;



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
//if (!InitialPrice)         {InitialPrice = StrToDouble(OrderComment());}
  
double myAccount = AccountBalance();  

Spread = (Ask-Bid);  
  
//Comment("Open Orders = ",total,"\nopenlongOrders = ",OpenLongOrders," \nopenShortOrders = ",
//OpenShortOrders,"\nPendLongs = ",PendLongs,
//"\nPendShorts = ",PendShorts,
//"\nProfit = ", getProfit(),
//"\nAccount Balance = ",myAccount,
//"\nSpread = ",Spread,
//"\nInitialPrice:  ",InitialPrice);  
  
  
  if(total == 2 && OpenLongOrders == 1 && OpenShortOrders == 1 && PendLongs == 0 && PendShorts == 0)
      {
             buystop();
      }
    if(total == 3 && OpenLongOrders == 2 && OpenShortOrders == 1 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop1();
      }  
      if(total == 4 && OpenLongOrders == 2 && OpenShortOrders == 2 && PendLongs == 0 && PendShorts == 0)
      {
             buystop1();
      }    
      
      if(total == 5 && OpenLongOrders == 3 && OpenShortOrders == 2 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop2();
      }
      if(total == 6 && OpenLongOrders == 3 && OpenShortOrders == 3 && PendLongs == 0 && PendShorts == 0)
      {
             buystop2();
      }
      if(total == 7 && OpenLongOrders == 4 && OpenShortOrders == 3 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop3();
      }
      if(total == 8 && OpenLongOrders == 4 && OpenShortOrders == 4 && PendLongs == 0 && PendShorts == 0)
      {
             buystop3();
      }
      if(total == 9 && OpenLongOrders == 5 && OpenShortOrders == 4 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop4();
      }
      if(total == 10 && OpenLongOrders == 5 && OpenShortOrders == 5 && PendLongs == 0 && PendShorts == 0)
      {
             buystop4();
      }
      if(total == 11 && OpenLongOrders == 6 && OpenShortOrders == 5 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop5();
      }
      if(total == 12 && OpenLongOrders == 6 && OpenShortOrders == 6 && PendLongs == 0 && PendShorts == 0)
      {
             buystop5();
      }
      if(total == 13 && OpenLongOrders == 7 && OpenShortOrders == 6 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop6();
      }
      if(total == 14 && OpenLongOrders == 7 && OpenShortOrders == 7 && PendLongs == 0 && PendShorts == 0)
      {
             buystop6();
      }
      if(total == 15 && OpenLongOrders == 8 && OpenShortOrders == 7 && PendLongs == 0 && PendShorts == 0)
      {
             sellstop7();
      }
      if(total == 16 && OpenLongOrders == 8 && OpenShortOrders == 8 && PendLongs == 0 && PendShorts == 0)
      {
             buystop7();
      }
      
      //if(total == 1 && OpenLongOrders == 0 && OpenShortOrders == 0 && (PendLongs == 1 || PendShorts == 1))
      //{
      //       deleteallpendingorders();
      //}
       
      //Sleep(2000);
      }
   } 
   
   CheckForClose();

//double InitialPriceFromComment;
//int z;
//
//for(z=total-1;z>=0;z--)
//{
//  OrderSelect(z,SELECT_BY_POS,MODE_TRADES);
//   {//continue;}
//   
//  if(OrderSymbol()==Symbol() && StrToDouble(OrderComment()) == InitialPrice)
//  {
//  if(!InitialPrice) {InitialPrice=StrToDouble(OrderComment());
//  //InitialPrice = OrderComment();
//  }
//  
//}
//}
//}
} // end of "onTick" function
  
//datetime GlobalVariableSet(string initialPrice,double InitialPrice);
//
//double StoreInitialPrice(double InitialPrice)
//{
//return(0);
//
//}

  
//+------------------------------------------------------------------+
void openbuy()
{
 if(InitialPrice != Ask){InitialPrice = Ask;}
 ticket = OrderSend(Symbol(),OP_BUY,lot1,Ask,3,InitialPrice-TakeProfit*Point,0,DoubleToStr(InitialPrice,MarketInfo(Symbol(),MODE_DIGITS)),MagicN,0,clrBlue);
 if(ticket<0){Print("Error opening order: ",GetLastError());}
  Comment("InitialPrice =  ",InitialPrice);
}

void sellstop()
{
 
 OrderSend(Symbol(),OP_SELLSTOP,lot2,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
 if(ticket<0){Print("Error opening order: ",GetLastError());}
 //Comment("InitialPrice =  ",InitialPrice);
}

void buystop()
{
 double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot3,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}
void sellstop1()
{ double InitialPrice;
 OrderSend(Symbol(),OP_SELLSTOP,lot4,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}


void buystop1()
{ double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot5,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}
void sellstop2()
{ double InitialPrice;
 OrderSend(Symbol(),OP_SELLSTOP,lot6,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop2()
{ double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot7,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop3()
{ double InitialPrice;
 OrderSend(Symbol(),OP_SELLSTOP,lot8,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop3()
{ double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot9,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop4()
{ double InitialPrice;
 OrderSend(Symbol(),OP_SELLSTOP,lot10,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop4()
{ double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot11,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop5()
 {double InitialPrice;
 OrderSend(Symbol(),OP_SELLSTOP,lot12,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop5()
{ double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot13,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop6()
{ double InitialPrice;
 OrderSend(Symbol(),OP_SELLSTOP,lot14,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop6()
{ double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot15,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void sellstop7()
{ double InitialPrice;
 OrderSend(Symbol(),OP_SELLSTOP,lot16,InitialPrice-TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}

void buystop7()
{ double InitialPrice;
 OrderSend(Symbol(),OP_BUYSTOP,lot17,InitialPrice+TakeProfit*Point,3,0,0,NULL,MagicN,0,clrBlue);
}




//=========================================================
//
//=========================================================

//void deleteallpendingorders()
//{
//   for(int i=0;i<OrdersTotal();i++)
//   {
//     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
//     if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicN && ((OrderType()==OP_BUY) || (OrderType()==OP_SELL) ||(OrderType()==OP_BUYSTOP) || (OrderType()==OP_SELLSTOP) || (OrderType()==OP_BUYLIMIT) || (OrderType()==OP_SELLLIMIT)))
//     {
//       OrderDelete(OrderTicket());
//     }   
//   }
//}


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
  
