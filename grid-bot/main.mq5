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
double gridCenterInput = 6334000 * _Point;
int gridNumberInput = 10; // Số chẵn
double gridAmountInput = 6000 * _Point; // Số chẵn
double gridSLInput = 10000 * _Point;

// Global
double gridStartGlobal = 0;

int OnInit() {
   if (gridNumberInput % 2 != 0) {
      Print("Grid Number invalid: ", gridNumberInput);
   }
   
   gridStartGlobal = gridCenterInput - (gridAmountInput / 2) - (gridAmountInput * ((gridNumberInput / 2) - 1));

   Print("OnInit: Point: ", _Point, " - Grid Center: ", gridCenterInput, " - Grid Number: ", gridNumberInput, " - Grid Amount: ", gridAmountInput,
         " - Volume: ", volumeInput, " - Grid SL: ", gridSLInput, " - Grid Start: ", gridStartGlobal);
         
   RemoveOrderAction();
   CreateOrderAction();
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
}

void OnTick() {
   int total = GetTotalOrderAndPosition();
   if (total != gridNumberInput) {
      Print("Total grid: ", total);
      //if (total > gridNumberInput) {
         //Print("Total grid error.");
         //RemoveOrderAction();
      //}
      
      CreateOrderAction();
   }
   
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double slDown = GetPriceByGridNumber(1) - gridSLInput;
   double slUp = GetPriceByGridNumber(gridNumberInput) + gridSLInput;
   if (bidPrice > slUp || bidPrice < slDown) {
      Print("Stop bot: ", bidPrice);
      RemoveOrderAction();
      ExpertRemove();
   }
}
