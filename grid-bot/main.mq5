#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\grid-bot\common\CommonFunction.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\grid-bot\common\CreateOrderAction.mqh>
#include <C:\Users\admin\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\bot-ea\grid-bot\common\RemoveOrderAction.mqh>

// Input
double volumeInput = 0.1;
double gridStartInput = 6121360 * _Point;
int gridNumberInput = 20;
double gridAmountInput = 3000 * _Point;
double gridSLInput = 3000 * _Point;

// Global

int OnInit() {
   if (gridNumberInput % 2 != 0) {
      Print("Grid Number invalid: ", gridNumberInput);
   }

   Print("OnInit: Point: ", _Point, " - Grid Start: ", gridStartInput, " - Grid Number: ", gridNumberInput, " - Grid Amount: ", gridAmountInput,
         " - Volume: ", volumeInput, " - Grid SL: ", gridSLInput);

   CreateOrderAction();
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
   RemoveOrderAction();
}

void OnTick() {
   int total = GetTotalOrderAndPosition();
   if (total != gridNumberInput) {
      CreateOrderAction();
   }
}
