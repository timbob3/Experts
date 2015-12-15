//+------------------------------------------------------------------+

//|                                          Scaling script v1.1.mq4 |

//|                                        Copyright ? 2011, tigpips |

//|                                                tigpips@gmail.com |

//+------------------------------------------------------------------+

#property copyright "Copyright ? 2011, tigpips"

#property link      "tigpips@gmail.com"


// Moded for Amart83

#property show_inputs



#include <WinUser32.mqh>



extern double Lots   = 0.01;
extern double Lots02 = 0.01;
extern double Lots03 = 0.01;
extern double Lots04 = 0.01;
extern double Lots05 = 0.01;
extern double Lots06 = 0.01;
extern double Lots07 = 0.01;
extern double Lots08 = 0.01;
extern double Lots09 = 0.01;
extern double Lots10 = 0.01;




extern int TakeProfit = 30;



extern int StopLoss   = 30;





extern int Slippage = 5;



extern int ScaleByPips02 = 1;
extern int ScaleByPips03 = 2;
extern int ScaleByPips04 = 3;
extern int ScaleByPips05 = 4;
extern int ScaleByPips06 = 5;
extern int ScaleByPips07 = 6;
extern int ScaleByPips08 = 7;
extern int ScaleByPips09 = 8;
extern int ScaleByPips10 = 9;







extern string Comment_Message = "";

extern int Magic = 4444444;





int start()

{

   double dropped_price;

   int i,Pos,Error,Total,t,t02,t03,t04,t05,t06,t07,t08,t09,t10;

   int ret;

   double OrderTP01, OrderSL01, OrderTP02, OrderSL02, OrderTP03, OrderSL03, OrderTP04, OrderSL04, OrderTP05,OrderSL05, OrderTP06,OrderSL06, OrderTP07,OrderSL07, OrderTP08,OrderSL08 , OrderTP09,OrderSL09 , OrderTP10,OrderSL10 ;

   

   if(Digits == 5 || Digits == 3)

   {

      ScaleByPips02 = ScaleByPips02 * 10;
      ScaleByPips03 = ScaleByPips03 * 10;
      ScaleByPips04 = ScaleByPips04 * 10;
      ScaleByPips05 = ScaleByPips05 * 10;
      ScaleByPips06 = ScaleByPips06 * 10;
      ScaleByPips07 = ScaleByPips07 * 10;
      ScaleByPips08 = ScaleByPips08 * 10;
      ScaleByPips09 = ScaleByPips09 * 10;
      ScaleByPips10 = ScaleByPips10 * 10;
      
      

      

      TakeProfit = TakeProfit * 10;
      

      StopLoss   = StopLoss   * 10;
    


   }

   dropped_price = WindowPriceOnDropped();

   ret=MessageBox("Cursor Price: "+DoubleToStr(dropped_price,Digits)+". To buy, click \"yes\". To sell, click \"No\".", "Question - Buy or Sell?", MB_YESNOCANCEL|MB_ICONQUESTION);

   if(ret==IDCANCEL)

   { 

      return(0);

   }

   //If Buy

   else if(ret==IDYES)

   {

      if(TakeProfit != 0)

      {

         OrderTP01 = dropped_price+(TakeProfit*Point);   

         OrderTP02 = dropped_price+(TakeProfit*Point);
         
         OrderTP03 = dropped_price+(TakeProfit*Point);
         
         OrderTP04 = dropped_price+(TakeProfit*Point);
         
         OrderTP05 = dropped_price+(TakeProfit*Point);
         
         OrderTP06 = dropped_price+(TakeProfit*Point);
         
         OrderTP07 = dropped_price+(TakeProfit*Point);
          
         OrderTP08 = dropped_price+(TakeProfit*Point);
         
         OrderTP09 = dropped_price+(TakeProfit*Point);
         
         OrderTP10 = dropped_price+(TakeProfit*Point);

      }

      else

      {

         OrderTP01 = 0;

         OrderTP02 = 0;
         
         OrderTP03 = 0;
         
         OrderTP04 = 0;
         
         OrderTP05 = 0;
         
         OrderTP06 = 0;
         
         OrderTP07 = 0;
         
         OrderTP08 = 0;
         
         OrderTP09 = 0;
         
         OrderTP10 = 0;
         

      }

      

      if(StopLoss != 0)

      {

         OrderSL01 = dropped_price-(StopLoss*Point);

         OrderSL02 = dropped_price-(StopLoss*Point);
         
         OrderSL03 = dropped_price-(StopLoss*Point);
         
         OrderSL04 = dropped_price-(StopLoss*Point);
         
         OrderSL05 = dropped_price-(StopLoss*Point);
         
         OrderSL06 = dropped_price-(StopLoss*Point);
         
         OrderSL07 = dropped_price-(StopLoss*Point);
         
         OrderSL08 = dropped_price-(StopLoss*Point);
         
         OrderSL09 = dropped_price-(StopLoss*Point);
         
         OrderSL10 = dropped_price-(StopLoss*Point);

      }

      else

      {

         OrderSL01 = 0;

         OrderSL02 = 0;
         
         OrderSL03 = 0;
         
         OrderSL04 = 0;
         
         OrderSL05 = 0;
         
         OrderSL06 = 0;
         
         OrderSL07 = 0;
         
         OrderSL08 = 0;
         
         OrderSL09 = 0;
         
         OrderSL10 = 0;

      }

      //if cursor above current price

      if(dropped_price > Ask)

      {

         t=OrderSend(Symbol(),OP_BUYSTOP,Lots,dropped_price,Slippage,OrderSL01,OrderTP01,Comment_Message,Magic,0,Lime);

         if(t<=0) Print("Error = ",GetLastError());

         else { Print("01st BUY STOP ticket = ",t);}

         

         t02=OrderSend(Symbol(),OP_BUYSTOP,Lots02,dropped_price+(ScaleByPips02*Point),Slippage,OrderSL02,OrderTP02,Comment_Message,Magic,0,Lime);

         if(t02<=0) Print("Error = ",GetLastError());

         else { Print("02nd BUY STOP ticket = ",t02);}  
         
         
         t03=OrderSend(Symbol(),OP_BUYSTOP,Lots03,dropped_price+(ScaleByPips03*Point),Slippage,OrderSL03,OrderTP03,Comment_Message,Magic,0,Lime);

         if(t03<=0) Print("Error = ",GetLastError());

         else { Print("03rd BUY STOP ticket = ",t03);} 
         
         
         t04=OrderSend(Symbol(),OP_BUYSTOP,Lots04,dropped_price+(ScaleByPips04*Point),Slippage,OrderSL04,OrderTP04,Comment_Message,Magic,0,Lime);

         if(t04<=0) Print("Error = ",GetLastError());

         else { Print("04th BUY STOP ticket = ",t04);} 
         
         
         t05=OrderSend(Symbol(),OP_BUYSTOP,Lots05,dropped_price+(ScaleByPips05*Point),Slippage,OrderSL05,OrderTP05,Comment_Message,Magic,0,Lime);

         if(t05<=0) Print("Error = ",GetLastError());

         else { Print("05th BUY STOP ticket = ",t05);} 
         
         
         t06=OrderSend(Symbol(),OP_BUYSTOP,Lots06,dropped_price+(ScaleByPips06*Point),Slippage,OrderSL06,OrderTP06,Comment_Message,Magic,0,Lime);

         if(t06<=0) Print("Error = ",GetLastError());

         else { Print("06th BUY STOP ticket = ",t06);} 
         
         
         t07=OrderSend(Symbol(),OP_BUYSTOP,Lots07,dropped_price+(ScaleByPips07*Point),Slippage,OrderSL07,OrderTP07,Comment_Message,Magic,0,Lime);

         if(t07<=0) Print("Error = ",GetLastError());

         else { Print("07th BUY STOP ticket = ",t07);} 
         
         
         t08=OrderSend(Symbol(),OP_BUYSTOP,Lots08,dropped_price+(ScaleByPips08*Point),Slippage,OrderSL08,OrderTP08,Comment_Message,Magic,0,Lime);

         if(t08<=0) Print("Error = ",GetLastError());

         else { Print("08th BUY STOP ticket = ",t08);} 
         
         
         t09=OrderSend(Symbol(),OP_BUYSTOP,Lots09,dropped_price+(ScaleByPips09*Point),Slippage,OrderSL09,OrderTP09,Comment_Message,Magic,0,Lime);

         if(t09<=0) Print("Error = ",GetLastError());

         else { Print("09th BUY STOP ticket = ",t09);} 
         
         
         t10=OrderSend(Symbol(),OP_BUYSTOP,Lots10,dropped_price+(ScaleByPips10*Point),Slippage,OrderSL10,OrderTP10,Comment_Message,Magic,0,Lime);

         if(t10<=0) Print("Error = ",GetLastError());

         else { Print("10th BUY STOP ticket = ",t10);} 
         
         

      }

      //if cursor below current price

      if(dropped_price < Bid)

      {

         t=OrderSend(Symbol(),OP_BUYLIMIT,Lots,dropped_price,Slippage,OrderSL01,OrderTP01,Comment_Message,Magic,0,Lime);

         if(t<=0) Print("Error = ",GetLastError());

         else { Print("01st BUY LIMIT ticket = ",t);}

         

         t02=OrderSend(Symbol(),OP_BUYLIMIT,Lots02,dropped_price-(ScaleByPips02*Point),Slippage,OrderSL02,OrderTP02,Comment_Message,Magic,0,Lime);

         if(t02<=0) Print("Error = ",GetLastError());

         else { Print("02nd BUY LIMIT ticket = ",t02);}  
         
         
         
         t03=OrderSend(Symbol(),OP_BUYLIMIT,Lots03,dropped_price-(ScaleByPips03*Point),Slippage,OrderSL03,OrderTP03,Comment_Message,Magic,0,Red);

         if(t03<=0) Print("Error = ",GetLastError());

         else { Print("03rd BUY LIMIT ticket = ",t03);}  



         t04=OrderSend(Symbol(),OP_BUYLIMIT,Lots04,dropped_price-(ScaleByPips04*Point),Slippage,OrderSL04,OrderTP04,Comment_Message,Magic,0,Lime);

         if(t04<=0) Print("Error = ",GetLastError());

         else { Print("04th BUY LIMIT ticket = ",t04);}  



         t05=OrderSend(Symbol(),OP_BUYLIMIT,Lots05,dropped_price-(ScaleByPips05*Point),Slippage,OrderSL05,OrderTP05,Comment_Message,Magic,0,Lime);

         if(t05<=0) Print("Error = ",GetLastError());

         else { Print("05th BUY LIMIT ticket = ",t05);}  


         t06=OrderSend(Symbol(),OP_BUYLIMIT,Lots06,dropped_price-(ScaleByPips06*Point),Slippage,OrderSL06,OrderTP06,Comment_Message,Magic,0,Lime);

         if(t06<=0) Print("Error = ",GetLastError());

         else { Print("06th BUY LIMIT ticket = ",t06);}  
         
         
         t07=OrderSend(Symbol(),OP_BUYLIMIT,Lots07,dropped_price-(ScaleByPips07*Point),Slippage,OrderSL07,OrderTP07,Comment_Message,Magic,0,Lime);

         if(t07<=0) Print("Error = ",GetLastError());

         else { Print("07th BUY LIMIT ticket = ",t07);}  


         t08=OrderSend(Symbol(),OP_BUYLIMIT,Lots08,dropped_price-(ScaleByPips08*Point),Slippage,OrderSL08,OrderTP08,Comment_Message,Magic,0,Lime);

         if(t08<=0) Print("Error = ",GetLastError());

         else { Print("08th BUY LIMIT ticket = ",t08);}  
        
         
         t09=OrderSend(Symbol(),OP_BUYLIMIT,Lots09,dropped_price-(ScaleByPips09*Point),Slippage,OrderSL09,OrderTP09,Comment_Message,Magic,0,Lime);

         if(t09<=0) Print("Error = ",GetLastError());

         else { Print("09th BUY LIMIT ticket = ",t09);}  
         
         
         t10=OrderSend(Symbol(),OP_BUYLIMIT,Lots10,dropped_price-(ScaleByPips10*Point),Slippage,OrderSL10,OrderTP10,Comment_Message,Magic,0,Lime);

         if(t10<=0) Print("Error = ",GetLastError());

         else { Print("10th BUY LIMIT ticket = ",t10);}  
         


      }

   }

   //If Sell

   else if(ret==IDNO)

   {

      if(TakeProfit != 0)

      {

         OrderTP01 = dropped_price-(TakeProfit*Point);   

         OrderTP02 = dropped_price-(TakeProfit*Point);
         
         OrderTP03 = dropped_price-(TakeProfit*Point);
         
         OrderTP04 = dropped_price-(TakeProfit*Point);
         
         OrderTP05 = dropped_price-(TakeProfit*Point);
         
         OrderTP06 = dropped_price-(TakeProfit*Point);
         
         OrderTP07 = dropped_price-(TakeProfit*Point);
         
         OrderTP08 = dropped_price-(TakeProfit*Point);
         
         OrderTP09 = dropped_price-(TakeProfit*Point);
         
         OrderTP10 = dropped_price-(TakeProfit*Point);






      }

      else

      {

         OrderTP01 = 0;

         OrderTP02 = 0;
         
         OrderTP03 = 0;
         
         OrderTP04 = 0;
         
         OrderTP05 = 0;
         
         OrderTP06 = 0;
         
         OrderTP07 = 0;
         
         OrderTP08 = 0;
         
         OrderTP09 = 0;
         
         OrderTP10 = 0;

      }

      

      if(StopLoss != 0)

      {

         OrderSL01 = dropped_price+(StopLoss*Point);

         OrderSL02 = dropped_price+(StopLoss*Point);
         
         OrderSL03 = dropped_price+(StopLoss*Point);
         
         OrderSL04 = dropped_price+(StopLoss*Point);
         
         OrderSL05 = dropped_price+(StopLoss*Point);
         
         OrderSL06 = dropped_price+(StopLoss*Point);
         
         OrderSL07 = dropped_price+(StopLoss*Point);
         
         OrderSL08 = dropped_price+(StopLoss*Point);
         
         OrderSL09 = dropped_price+(StopLoss*Point);
         
         OrderSL10 = dropped_price+(StopLoss*Point);

      }

      else

      {

         OrderSL01 = 0;

         OrderSL02 = 0;
         
         OrderSL03 = 0;
         
         OrderSL04 = 0;
         
         OrderSL05 = 0;
         
         OrderSL06 = 0;
         
         OrderSL07 = 0;
         
         OrderSL08 = 0;
         
         OrderSL09 = 0;
         
         OrderSL10 = 0;

      }

               

      if(dropped_price > Ask)

      {

         t=OrderSend(Symbol(),OP_SELLLIMIT,Lots,dropped_price,Slippage,OrderSL01,OrderTP01,Comment_Message,Magic,0,Red);

         if(t<=0) Print("Error = ",GetLastError());

         else { Print("01st SELL LIMIT ticket = ",t);}

         

         

         t02=OrderSend(Symbol(),OP_SELLLIMIT,Lots02,dropped_price+(ScaleByPips02*Point),Slippage,OrderSL02,OrderTP02,Comment_Message,Magic,0,Red);

         if(t02<=0) Print("Error = ",GetLastError());

         else { Print("02nd SELL LIMIT ticket = ",t02);} 
         
         
         
         t03=OrderSend(Symbol(),OP_SELLLIMIT,Lots03,dropped_price+(ScaleByPips03*Point),Slippage,OrderSL03,OrderTP03,Comment_Message,Magic,0,Red);

         if(t03<=0) Print("Error = ",GetLastError());

         else { Print("03rd SELL LIMIT ticket = ",t03);} 
         
         
         
         t04=OrderSend(Symbol(),OP_SELLLIMIT,Lots04,dropped_price+(ScaleByPips04*Point),Slippage,OrderSL04,OrderTP04,Comment_Message,Magic,0,Red);

         if(t04<=0) Print("Error = ",GetLastError());

         else { Print("04th SELL LIMIT ticket = ",t04);} 
         
         
         
         t05=OrderSend(Symbol(),OP_SELLLIMIT,Lots05,dropped_price+(ScaleByPips05*Point),Slippage,OrderSL05,OrderTP05,Comment_Message,Magic,0,Red);

         if(t05<=0) Print("Error = ",GetLastError());

         else { Print("05th SELL LIMIT ticket = ",t05);} 
         
         
         t06=OrderSend(Symbol(),OP_SELLLIMIT,Lots06,dropped_price+(ScaleByPips06*Point),Slippage,OrderSL06,OrderTP06,Comment_Message,Magic,0,Red);

         if(t06<=0) Print("Error = ",GetLastError());

         else { Print("06th SELL LIMIT ticket = ",t06);}  
         
         
         t07=OrderSend(Symbol(),OP_SELLLIMIT,Lots07,dropped_price+(ScaleByPips07*Point),Slippage,OrderSL07,OrderTP07,Comment_Message,Magic,0,Red);

         if(t07<=0) Print("Error = ",GetLastError());

         else { Print("07th SELL LIMIT ticket = ",t07);} 
         
         
         t08=OrderSend(Symbol(),OP_SELLLIMIT,Lots08,dropped_price+(ScaleByPips08*Point),Slippage,OrderSL08,OrderTP08,Comment_Message,Magic,0,Red);

         if(t08<=0) Print("Error = ",GetLastError());

         else { Print("08th SELL LIMIT ticket = ",t08);}  
         
         
         t09=OrderSend(Symbol(),OP_SELLLIMIT,Lots09,dropped_price+(ScaleByPips09*Point),Slippage,OrderSL09,OrderTP09,Comment_Message,Magic,0,Red);

         if(t09<=0) Print("Error = ",GetLastError());

         else { Print("09th SELL LIMIT ticket = ",t09);} 
         
         
         t10=OrderSend(Symbol(),OP_SELLLIMIT,Lots10,dropped_price+(ScaleByPips10*Point),Slippage,OrderSL10,OrderTP10,Comment_Message,Magic,0,Red);

         if(t10<=0) Print("Error = ",GetLastError());

         else { Print("09th SELL LIMIT ticket = ",t10);}  
         
         
         
              

      }

      if(dropped_price < Bid)

      {

         t=OrderSend(Symbol(),OP_SELLSTOP,Lots,dropped_price,Slippage,OrderSL01,OrderTP01,Comment_Message,Magic,0,Red);

         if(t<=0) Print("Error = ",GetLastError());

         else { Print("1st SELL STOP ticket = ",t);}

         

         

         t02=OrderSend(Symbol(),OP_SELLSTOP,Lots02,dropped_price-(ScaleByPips02*Point),Slippage,OrderSL02,OrderTP02,Comment_Message,Magic,0,Red);

         if(t02<=0) Print("Error = ",GetLastError());

         else { Print("02nd SELL LTOP ticket = ",t02);}    
         
         
         
         t03=OrderSend(Symbol(),OP_SELLSTOP,Lots03,dropped_price-(ScaleByPips03*Point),Slippage,OrderSL03,OrderTP03,Comment_Message,Magic,0,Red);

         if(t03<=0) Print("Error = ",GetLastError());

         else { Print("03rd SELL LTOP ticket = ",t03);} 
         
         
         t04=OrderSend(Symbol(),OP_SELLSTOP,Lots04,dropped_price-(ScaleByPips04*Point),Slippage,OrderSL04,OrderTP04,Comment_Message,Magic,0,Red);

         if(t04<=0) Print("Error = ",GetLastError());

         else { Print("04th SELL LTOP ticket = ",t04);} 
         
         
         
         t05=OrderSend(Symbol(),OP_SELLSTOP,Lots05,dropped_price-(ScaleByPips05*Point),Slippage,OrderSL05,OrderTP05,Comment_Message,Magic,0,Red);

         if(t05<=0) Print("Error = ",GetLastError());

         else { Print("05th SELL LTOP ticket = ",t05);} 
         
         
         
         t06=OrderSend(Symbol(),OP_SELLSTOP,Lots06,dropped_price-(ScaleByPips06*Point),Slippage,OrderSL06,OrderTP06,Comment_Message,Magic,0,Red);

         if(t06<=0) Print("Error = ",GetLastError());

         else { Print("06th SELL LTOP ticket = ",t06);}   
         
         
         t07=OrderSend(Symbol(),OP_SELLSTOP,Lots07,dropped_price-(ScaleByPips07*Point),Slippage,OrderSL07,OrderTP07,Comment_Message,Magic,0,Red);

         if(t07<=0) Print("Error = ",GetLastError());

         else { Print("07th SELL LTOP ticket = ",t07);} 
         
         
         
         t08=OrderSend(Symbol(),OP_SELLSTOP,Lots08,dropped_price-(ScaleByPips08*Point),Slippage,OrderSL08,OrderTP08,Comment_Message,Magic,0,Red);

         if(t08<=0) Print("Error = ",GetLastError());

         else { Print("8th SELL LTOP ticket = ",t08);}   
               
               
         t09=OrderSend(Symbol(),OP_SELLSTOP,Lots09,dropped_price-(ScaleByPips09*Point),Slippage,OrderSL09,OrderTP09,Comment_Message,Magic,0,Red);

         if(t09<=0) Print("Error = ",GetLastError());

         else { Print("09th SELL LTOP ticket = ",t09);}   
                     
                     
         t10=OrderSend(Symbol(),OP_SELLSTOP,Lots10,dropped_price-(ScaleByPips10*Point),Slippage,OrderSL10,OrderTP10,Comment_Message,Magic,0,Red);

         if(t10<=0) Print("Error = ",GetLastError());

         else { Print("10th SELL LTOP ticket = ",t10);}   
                                 

      }

   }           

   return(0);

}

//+------------------------------------------------------------------+