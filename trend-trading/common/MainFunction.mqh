#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CreateOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/RemoveOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CreateValueGlobal.mqh>

// Input
extern int totalOrderInput;
extern double volumeInput;
extern double gridAmountInput;
extern int limitPositionInput;
extern ulong magicNumberInput;

// Global
int gridNoCurrentGlobal = 0;
int differenceBuyAndSellGlobal = 0; // Nếu value > 0 => Buy > Sell

// Constants
int DELAY_SECOND_CONSTANT = 10;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";

int OnInitFunction()
{
    // RemoveOrderAll();

    if (totalOrderInput % 2 != 0)
    {
        Print("Grid total invalid.");
        ExpertRemove();
        return (INIT_SUCCEEDED);
    }

    Print("Start bot");

    MainFunction();

    EventSetTimer(DELAY_SECOND_CONSTANT);

    return (INIT_SUCCEEDED);
}

void MainFunction()
{
    int gridNoCurrentNew = GetGridNoCurrent();
    if (gridNoCurrentNew <= 0)
    {
        return;
    }
    if (gridNoCurrentGlobal != gridNoCurrentNew)
    {
        gridNoCurrentGlobal = gridNoCurrentNew;
        Print("Grid no current: ", gridNoCurrentGlobal);
    }

    RefreshGlobalVariable();
    RemoveOrderAction();
    CreateOrderAction();
}

void RefreshGlobalVariable()
{
    int differenceBuyAndSellNew = GetDifferenceBuyAndSell();
    if (differenceBuyAndSellNew != differenceBuyAndSellGlobal)
    {
        differenceBuyAndSellGlobal = differenceBuyAndSellNew;
        Print("Difference Buy and Sell: ", differenceBuyAndSellGlobal);
    }
}
