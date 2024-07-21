#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trending-grid/common/CreateValueGlobal.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trending-grid/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trending-grid/common/CreateOrderAction.mqh>

// Input
extern double priceCenterInput;
extern double gridAmountInput;
extern double slGridAmountInput;
extern int totalGridInput;
extern double volumeInput;
extern int magic2Input;

// Global
int magic1Global = 111;
double priceStartGridGlobal = 0;
ulong magicNoGlobal = 0;

// Constants
int DELAY_SECOND_CONSTANT = 10;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";
string UNKNOWN_CONSTANT = "UNKNOWN";

int OnInitFunction()
{
    Print("Start bot");
    magicNoGlobal = GetMagicNo();
    Print("Input: Price center: ", priceCenterInput, " - Grid amount: ", gridAmountInput, " - SL Grid: ", slGridAmountInput, " - Total grid: ", totalGridInput, " - Volume: ", volumeInput, " - Magic:", magicNoGlobal);

    MainFunction();

    EventSetTimer(DELAY_SECOND_CONSTANT);

    return (INIT_SUCCEEDED);
}

void MainFunction()
{
    RefreshGlobalVariable();
    CreateOrderAction();
}

void RefreshGlobalVariable()
{
    double priceStartGridNew = GetPriceStartGrid();
    if (CompareDouble(priceStartGridNew, priceStartGridGlobal) != 0)
    {
        priceStartGridGlobal = priceStartGridNew;
        Print("Price start grid: ", priceStartGridGlobal);
    }
}
