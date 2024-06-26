#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\forexfactory\common\ModifyOrderStopAction.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\forexfactory\common\ModifyPositionSLAction.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\forexfactory\common\RemoveOrderAction.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\forexfactory\common\CreateOrderStopAction.mqh>

// Input
double volumeInput = 0.01;
ulong deviationInput = 5;
double stopPriceRateInput = 300 * _Point;
double stopPriceSLRateInput = 2000 * _Point;
double stopPriceTPRateInput = 10000 * _Point;
double limitModifyPriceInput = 20 * _Point;

int OnInit() {
   Print("OnInit: Point: ", _Point, " - Rate stop: ", stopPriceRateInput, " - Rate SL: ", stopPriceSLRateInput, " - Rate TP: ", stopPriceTPRateInput,
         " - Volume: ", volumeInput, " - Deviation: ", deviationInput, " - Limit modify: ", limitModifyPriceInput);

   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Print("OnInit: Bid: ", bidPrice, " - Ask: ", askPrice);
   
   //double price = iClose(Symbol(), PERIOD_CURRENT, 0);
   
   CreateOrderStopAction(bidPrice, askPrice, ORDER_TYPE_BUY_STOP);
   CreateOrderStopAction(bidPrice, askPrice, ORDER_TYPE_SELL_STOP);

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
}

void OnTick() {
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Print("OnTick: Giá mua: ", bidPrice, " - Giá bán: ", askPrice);
   
   RemoveOrderAction();
   ModifyOrderStopAction(bidPrice, askPrice);
   ModifyPositionSLAction(bidPrice, askPrice);
   
   //ExpertRemove();
}
