#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CreateValueGlobal.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CreateOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/TakeProfitAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/RemoveOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/ModifyPositionTPSLAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/MagicDetailObject.mqh>

// Input
extern int magic2Input;
extern bool isOnlyRunOnceInput;
extern string symbolInput;
extern int totalMagicInput;
extern string takeProfitFirstInput;

// Global
bool isHasRunOnceGlobal = false;
int magic1Global = 666;

MagicDetailObject magicDetailArrGlobal[];

// Constants
int DELAY_SECOND_CONSTANT = 10;
string BUY_TYPE_CONSTANT = "BUY";
string SELL_TYPE_CONSTANT = "SELL";
string UNKNOWN_CONSTANT = "UNKNOWN";

int OnInitFunction()
{
    if (symbolInput != _Symbol)
    {
        Print("Symbol is invalid.");
        ExpertRemove();
        return (INIT_SUCCEEDED);
    }

    if (takeProfitFirstInput != BUY_TYPE_CONSTANT && takeProfitFirstInput != SELL_TYPE_CONSTANT)
    {
        Print("Take profit first is invalid.");
        ExpertRemove();
        return (INIT_SUCCEEDED);
    }

    Print("Start bot");
    Print("Input: Take profit first: ", takeProfitFirstInput, " - Limit: ", limitGridInput, " - Is only run once: ", isOnlyRunOnceInput, " - SL: ", slAmountInput, " - TP: ", tpNumberInput, " - Volume: ", volumeInput, " - Magic: ", GetMagic1And2Str());

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
    SetMagicDetailArr();
}

void SetMagicDetailArr()
{
    MagicDetailObject magicDetailArrNew[];

    SetValueForMagicDetail(magicDetailArrNew);

    for (int i = 0; i < ArraySize(magicDetailArrNew); i++)
    {
        MagicDetailObject magicDetailNew = magicDetailArrNew[i];
        MagicDetailObject magicDetailOld = GetMagicDetailByMagicNo(magicDetailArrGlobal, magicDetailNew.magicNo);

        if (magicDetailOld.totalPosition > 0 && magicDetailOld.totalPosition > magicDetailNew.totalPosition)
        {
            Print("Magic: ", magicDetailNew.magicNo, " - Close all position.");
            CloseAllPositionByMagicNo(magicDetailNew.magicNo);
            magicDetailNew.totalPosition = 0;
        }
    }

    if (!IsEqualArrMagicDetail(magicDetailArrGlobal, magicDetailArrNew))
    {
        CopyArrMagicDetail(magicDetailArrNew, magicDetailArrGlobal);
        ArrayPrint(magicDetailArrGlobal);
    }
}
