//+------------------------------------------------------------------+
//|                                            Scaling script v1.mq4 |
//|                                        Copyright © 2011, tigpips |
//|                                                tigpips@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, tigpips"
#property link      "tigpips@gmail.com"
#property show_inputs

extern int Slippage = 0;
extern int ScaleByPips = 20;
extern string Comment_Message = "";
extern int Magic = 5555555;


int start()
{

   bool Result;

   int i,Pos,Error,Total,t;
   string ordersymbol;
   int ordertype,orderticket;
   double orderopenprice,orderlots,ordertp_pips,ordersl_pips,newtp_price,newsl_price;
   
   ordersl_pips = 0;
   ordertp_pips = 0;
   
   if(Digits == 5 || Digits == 3)
   {
      ScaleByPips = ScaleByPips * 10;
   }
   Total=OrdersTotal();
   if(Total>0)
   { 
     for(i=Total-1; i>=0; i--) 
      {  if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true) 
         { 
            orderopenprice = OrderOpenPrice();
            orderlots = OrderLots();
            ordersymbol = OrderSymbol();
            ordertype = OrderType();
            orderticket =OrderTicket();
            if(OrderType() == OP_SELL)
            {
               if(OrderStopLoss() != 0)
               {
                  ordersl_pips = (OrderStopLoss() - OrderOpenPrice())* Find_multiplier();
               }
               if(OrderTakeProfit() != 0 )
               {
                  ordertp_pips = (OrderOpenPrice() - OrderTakeProfit())*Find_multiplier();
               }
               
            }
            else if(OrderType() == OP_BUY)
            {
               if(OrderTakeProfit() != 0 )
               {               
                  ordertp_pips = (OrderTakeProfit() - OrderOpenPrice())*Find_multiplier();
               }
               if(OrderStopLoss() != 0)
               {               
                  ordersl_pips = (OrderOpenPrice() - OrderStopLoss())*Find_multiplier();     
               }
            }
         }
      }
   }
   //Place 2nd Order
   if(Comment_Message == "")
   {
      Comment_Message = " Scale "+listpips(ScaleByPips)+" pips from #"+orderticket;  
   }
   if(ordertype == OP_SELL)
   {             
      if(ordertp_pips != 0)
      {
         newtp_price = (orderopenprice-ScaleByPips*Point)-(ordertp_pips*Point);
      }
      else
      {
         newtp_price = 0;
      }
      if(ordersl_pips != 0)
      {
         newsl_price = (orderopenprice-ScaleByPips*Point)+(ordersl_pips*Point);
      }
      else
      {
         newsl_price = 0;
      }      
      t=OrderSend(ordersymbol,OP_SELLSTOP,orderlots,orderopenprice-ScaleByPips*Point,Slippage,newsl_price,newtp_price,Comment_Message,Magic,0,Red);
      if(t<=0) Print("Error = ",GetLastError());
      else { Print("New ticket = ",t);}
   }
   else if(ordertype == OP_BUY)
   {
      if(ordertp_pips != 0)
      {
         newtp_price = (orderopenprice+ScaleByPips*Point)+(ordertp_pips*Point);
      }
      else
      {
         newtp_price = 0;
      }
      if(ordersl_pips != 0)
      {
         newsl_price = (orderopenprice+ScaleByPips*Point)-(ordersl_pips*Point);
      }
      else
      {
         newsl_price = 0;
      }       
      t=OrderSend(ordersymbol,OP_BUYSTOP,orderlots,orderopenprice+ScaleByPips*Point,Slippage,newsl_price,newtp_price,Comment_Message,Magic,0,Blue);
      if(t<=0) Print("Error = ",GetLastError());
      else { Print("New ticket = ",t);}                 
   }   
           
   return(0);
}
//+------------------------------------------------------------------+
int Find_multiplier()
{
   if(Digits==5)
   {
      return(100000);
   }
   else if(Digits == 4)
   {
      return(10000);
   }
   else if(Digits == 3)
   {
      return(1000);
   }
   else if(Digits == 2)
   {
      return(100);
   }
}

int listpips(int pips)
{
   int result;
   if(Digits == 5 || Digits == 3)
   {
      result = pips/10;
      return(result);    
   }
}