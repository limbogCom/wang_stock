class CountStock{
  final String countStockId;
  final String countStockCode;
  final String countStockProdCode;
  final String countStockProdName;
  final String countStockProdPic;
  final String countStockProdUnit1;
  final String countStockProdUnit2;
  final String countStockProdUnit3;
  final String countStockProdStockQ;
  final String countStockBalance;
  final String countStockDateAdd;
  final String countStockEmpAdd;
  final String countStockDateCount;
  final String countStockNumCount;
  final String countStockStatus;
  final String countStockPrint;
  final String countStockTimePrint;
  final String countStockInProcess;
  final String countStockSentNum;
  final String countStockNewCount;
  final String countStockEmpCount;
  final String countStockComment;
  final String countStockLine;

  CountStock({
    this.countStockId,
    this.countStockCode,
    this.countStockProdCode,
    this.countStockProdName,
    this.countStockProdPic,
    this.countStockProdUnit1,
    this.countStockProdUnit2,
    this.countStockProdUnit3,
    this.countStockProdStockQ,
    this.countStockBalance,
    this.countStockDateAdd,
    this.countStockEmpAdd,
    this.countStockDateCount,
    this.countStockNumCount,
    this.countStockStatus,
    this.countStockPrint,
    this.countStockTimePrint,
    this.countStockInProcess,
    this.countStockSentNum,
    this.countStockNewCount,
    this.countStockEmpCount,
    this.countStockComment,
    this.countStockLine
  });

  factory CountStock.fromJson(Map<String, dynamic> json){
    return new CountStock(
      countStockId: json['ctl_id'],
      countStockCode: json['ct_code'],
      countStockProdCode: json['ctl_pcode'],
      countStockProdName: json['nproduct'],
      countStockProdPic: json['pic'],
      countStockProdUnit1: json['unit1'],
      countStockProdUnit2: json['unit2'],
      countStockProdUnit3: json['unit3'],
      countStockProdStockQ: json['stockQ'],
      countStockBalance: json['ctl_stock'],
      countStockDateAdd: json['ctl_dateadd'],
      countStockEmpAdd: json['ctl_empadd'],
      countStockDateCount: json['ctl_datecount'],
      countStockNumCount: json['ctl_numcount'],
      countStockStatus: json['ctl_status'],
      countStockPrint: json['ctl_print'],
      countStockTimePrint: json['ctl_timeprint'],
      countStockInProcess: json['ctl_inprocess'],
      countStockSentNum: json['ctl_sentnum'],
      countStockNewCount: json['ctl_newcount'],
      countStockEmpCount: json['ctl_empcount'],
      countStockComment: json['ctl_comments'],
      countStockLine: json['ctl_line'],
    );
  }
}