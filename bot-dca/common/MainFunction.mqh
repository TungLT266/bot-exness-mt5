#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CreateValueGlobal.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CreateOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/TakeProfitAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/RemoveOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/ModifyPositionTPSLAction.mqh>

// Input
extern ulong magicNumberInput;
extern bool isOnlyRunOnceInput;

// Global
double priceStartGlobal = 0;
bool isTakeProfitBuyGlobal;
bool isTradeBuyFirstGlobal;
bool isHasRunOnceGlobal = false;

// Constants
int DELAY_SECOND_CONSTANT = 10;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";

int OnInitFunction()
{
    Print("Start bot");
    Print("Input: Is trade buy first: ", isTradeBuyFirstInput, " - Limit: ", limitGridInput, " - Is only run once: ", isOnlyRunOnceInput, " - SL: ", slAmountInput, " - TP: ", tpNumberInput, " - Volume: ", volumeInput, " - Magic: ", magicNumberInput);

    isTradeBuyFirstGlobal = isTradeBuyFirstInput;
    isTakeProfitBuyGlobal = isTradeBuyFirstInput;

    MainFunction();

    EventSetTimer(DELAY_SECOND_CONSTANT);

    return (INIT_SUCCEEDED);
}

void MainFunction()
{
    if (GetTotalPosition() == 0)
    {
        RemoveOrderAction();
        if (isHasRunOnceGlobal && isOnlyRunOnceInput)
        {
            Print("Stop bot.");
            ExpertRemove();
            return;
        }
    }

    RefreshGlobalVariable();
    CreateOrderAction();

    RefreshGlobalVariable();
    ModifyPositionTPSLAction();
    TakeProfitAction();

    isHasRunOnceGlobal = true;
}

void RefreshGlobalVariable()
{
    SetPriceStartAndIsTradeBuyFirst();

    bool isTakeProfitBuyNew = GetIsTakeProfitBuy();
    if (isTakeProfitBuyGlobal != isTakeProfitBuyNew)
    {
        isTakeProfitBuyGlobal = isTakeProfitBuyNew;
        if (isTakeProfitBuyGlobal)
        {
            Print("Direction Up.");
        }
        else
        {
            Print("Direction Down.");
        }
    }
}
