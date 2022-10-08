import 'package:gsheets/gsheets.dart';
import 'package:crckclivestreamhelper/auth/secrets.dart';

class CrckcHelperAPI {
  static final _credentials = SECRETS.gSheetCredentials; //Secret
  static final _spreadsheetId = SECRETS.gSheetId;
  //Secret
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _userSheet = await _getWorkSheet(spreadsheet, title: 'DataToday');
    _userSheet!.values.insertRow(1, ["Speaker", "Topic", "Verse"]);
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      // print(e);
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<String> rowList) async {
    if (_userSheet == null) return;
    _userSheet!.values.insertRow(2, rowList);
  }
}
