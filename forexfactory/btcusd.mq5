//+------------------------------------------------------------------+
//|                                                           s1.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\forexfactory\common.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\forexfactory\common\ModifyOrderStopAction.mqh>

// Input
double volume = 0.01;
ulong deviation = 5;
double stopPriceRate = 300 * _Point;
double stopPriceSLRate = 2000 * _Point;
double stopPriceTPRate = 10000 * _Point;
double limitModifyPrice = 20 * _Point;

// Variable

//+------------------------------------------------------------------+

int OnInit() {
   Print("OnInit: Point: ", _Point, " - Rate stop: ", stopPriceRate, " - Rate SL: ", stopPriceSLRate, " - Rate TP: ", stopPriceTPRate,
         " - Volume: ", volume, " - Deviation: ", deviation, " - Limit modify: ", limitModifyPrice);

   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Print("OnInit: Bid: ", bidPrice, " - Ask: ", askPrice);
   
   //double price = iClose(Symbol(), PERIOD_CURRENT, 0);
   
   CreateOrderStopAction(bidPrice, askPrice, ORDER_TYPE_BUY_STOP, volume, deviation, stopPriceRate, stopPriceSLRate, stopPriceTPRate);
   CreateOrderStopAction(bidPrice, askPrice, ORDER_TYPE_SELL_STOP, volume, deviation, stopPriceRate, stopPriceSLRate, stopPriceTPRate);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+

void OnDeinit(const int reason) {
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
}

//+------------------------------------------------------------------+

void OnTick() {
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Print("OnTick: Giá mua: ", bidPrice, " - Giá bán: ", askPrice);
   
   //int total = PositionsTotal();
   RemoveOrderAction();
   ModifyOrderStopAction(bidPrice, askPrice, deviation, stopPriceRate, stopPriceSLRate, stopPriceTPRate, limitModifyPrice);
   
   //ExpertRemove();
}

//+------------------------------------------------------------------+
