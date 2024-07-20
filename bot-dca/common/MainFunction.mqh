#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CreateValueGlobal.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CreateOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/TakeProfitAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/RemoveOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/ModifyPositionTPSLAction.mqh>

// Input
extern int magic2Input;
extern bool isOnlyRunOnceInput;
extern string symbolInput;
extern int totalMagicInput;

// Global
bool isHasRunOnceGlobal = false;
int magic1Global = 666;

int magic3ArrGlobal[];
double slAmountArrGlobal[];
double priceStartArrGlobal[];
string takeProfitCurrentArrGlobal[];
string takeProfitStartArrGlobal[];
int totalPositionArrGlobal[];

// Constants
int DELAY_SECOND_CONSTANT = 10;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";
string UNKNOWN_CONSTANT = "UNKNOWN";

int OnInitFunction()
{
    if (symbolInput != _Symbol)
    {
        Print("Symbol invalid.");
        ExpertRemove();
        return (INIT_SUCCEEDED);
    }

    Print("Start bot");
    Print("Input: Is trade buy first: ", isTradeBuyFirstInput, " - Limit: ", limitGridInput, " - Is only run once: ", isOnlyRunOnceInput, " - SL: ", slAmountInput, " - TP: ", tpNumberInput, " - Volume: ", volumeInput, " - Magic: ", magicNumberInput);

    MainFunction();

    isHasRunOnceGlobal = true;

    EventSetTimer(DELAY_SECOND_CONSTANT);

    return (INIT_SUCCEEDED);
}

void MainFunction()
{
    if (GetTotalPosition() == 0)
    {
        RemoveOrderAll();
        if (isHasRunOnceGlobal && isOnlyRunOnceInput)
        {
            Print("Stop bot.");
            ExpertRemove();
            return;
        }
    }

    RefreshGlobalVariable();
    RemoveOrderAction();
    CreateOrderAction();

    RefreshGlobalVariable();
    ModifyPositionTPSLAction();
    TakeProfitAction();
}

void RefreshGlobalVariable()
{
    SetMagic3Arr();
    SetTotalPositionArr();
    SetMagicDependentArr();
}

void SetTotalPositionArr()
{
    int sizeNew = ArraySize(magic3ArrGlobal);
    ArrayResize(totalPositionArrGlobal, sizeNew);

    for (int i = 0; i < sizeNew; i++)
    {
        int magic3 = magic3ArrGlobal[i];
        int totalPositionNew = GetTotalPositionByMagic3(magic3);
        if (totalPositionArrGlobal[i] != totalPositionNew)
        {
            if (totalPositionArrGlobal[i] > totalPositionNew)
            {
                Print("Magic 3: ", magic3, " - Close all position.");
                CloseAllPositionByMagic3(magic3);
                totalPositionNew = 0;
            }
            totalPositionArrGlobal[i] = totalPositionNew;
            Print("Magic 3: ", magic3, " - Total position: ", totalPositionNew);
        }
    }
}
