import 'dart:io';
import 'package:path_provider/path_provider.dart';

 const String dictionary =
     'Августовский\n1\nанАтом\n1\nантитЕза\n1\nапострОф\n1\nаристокрАтия\n1\nасимметрИя\n1\nАтлас (собрание географ.карт)\n1\nатлАс (ткань)\n1\nафЕра\n1\nаэропОрты\n1\nбалОванный\n1\nбаловАть\n1\nбаловнИк\n1\nбалУясь\n1\nбАнта\n1\nбАнты\n1\nбАрмен\n1\nберЁста\n1\nблАговест\n1\nблаговолИть\n1\nбОроду\n1\nбОчковый\n1\nбралА\n1\nбралАсь\n1\nбрОня (закрепление чего-нибудь за чем-нибудь)\n1\nбронЯ (защитная обшивка)\n1\nбуржуазИя\n1\nбухгАлтеров\n1\nваловОй\n1\nвЕрба\n1\nвернА\n1\nвероисповЕдание\n1\nвзбешЕнный\n1\nвзялА\n1\nвзялАсь\n1\nвключЕнный\n1\nвключЕн\n1\nвключИшь\n1\nвключИт\n1\nвключИм\n1\nвлилАсь\n1\nвОвремя\n1\nводопровОд\n1\nволгодОнский\n1\nвОлка\n1\nвОлки\n1\nволкОв\n1\nвОра\n1\nвОры\n1\nворОв\n1\nворАм\n1\nворАх (пр.падеж)\n1\nворвАться\n1\nворвалАсь\n1\nвоспринЯть\n1\nвоспринялА\n1\nвоссоздАть\n1\nвоссоздалА\n1\nвручИт\n1\nгазопровОд\n1\nгастронОмия\n1\nгектАр\n1\nгЕнезис\n1\nгладкошЕрстный\n1\nгналА\n1\nгналАсь\n1\nгравЕр\n1\nгренадЕр\n1\nгрУшевый\n1\nдавнИшний\n1\nдерматИн\n1\nдешевИзна\n1\nдиспансЕр\n1\nдобелА\n1\nдобралА\n1\nдобралАсь\n1\nдовезЕнный\n1\nдОверху\n1\nдОгмат\n1\nдоговОр\n1\nдоговорЕнность\n1\nдоговОрный\n1\nдождалАсь\n1\nдозвонИтся\n1\nдозвонЯтся\n1\nдозИровать\n1\nдонЕльзя\n1\nдОнизу\n1\nдосУг\n1\nдОсуха\n1\nдочернА\n1\nдраматургИя\n1\nдремОта\n1\nдуховнИк\n1\nеретИк\n1\nжалюзИ\n1\nждалА\n1\nжитиЕ\n1\nжИться\n1\nжилОсь\n1\nзабронИровать (закрепить что-нибудь за кем-нибудь)\n1\nзабронировАть (покрыть броней)\n1\nзавИдно\n1\nзаворожЕнный\n1\nзАговор\n1\nзАгодя\n1\nзАгнутый\n1\nзадОлго\n1\nзаЕм\n1\nзакУпорить\n1\nзакУпорив\n1\nзакУпорка\n1\nзанятОй (человек)\n1\nзАнятый (кем-нибудь)\n1\nзАнял\n1\nзанялА\n1\nзАняло\n1\nзАняли\n1\nзаперлАсь\n1\nзапертА\n1\nзАсветло\n1\nзаселЕнный\n1\nзаселенА\n1\nзАтемно\n1\nзвалА\n1\nзвонИть\n1\nзвонИшь\n1\nзвонИт\n1\nзвонЯт\n1\nзимОвщик\n1\nзнАмение\n1\nзнАхарство\n1\nзнАчимость\n1\nзнАчимый\n1\nзубчАтый\n1\nИгрище\n1\nизбалОванный\n1\nИздавна\n1\nИзредка\n1\nИконопись\n1\nИксы\n1\nинформИровать\n1\nисключИть\n1\nисключИт\n1\nИскра\n1\nИсстари\n1\nисчЕрпать\n1\nкаталОг\n1\nкАтарсис\n1\nкАшлянуть\n1\nквартАл\n1\nкедрОвый\n1\nкинематогрАфия\n1\nклАла\n1\nклЕенный (прич)\n1\nклеЕнный (прил)\n1\nкожЕвенный\n1\nкоклЮш\n1\nколлЕж\n1\nколОсс\n1\nкОмпас\n1\nкОнусы\n1\nкормЯщий\n1\nкорЫсть\n1\nкрАны\n1\nкрапИва\n1\nкрасИвее\n1\nкрасИвейший\n1\nкрАла\n1\nкрАлась\n1\nкремЕнь\n1\nкремнЯ\n1\nкровоточАщий\n1\nкровоточИть\n1\nкУхонный\n1\nлгалА\n1\nлЕктор\n1\nлЕкторов\n1\nлилАсь\n1\nловкА\n1\nломОта\n1\nломОть\n1\nлОскут (отходы, остатки)\n1\nлоскУт (кусочек ткани)\n1\nлососЕвый\n1\nлубОчный\n1\nлыжнЯ\n1\nмастерствО\n1\nмЕльком\n1\nмЕстностей\n1\nмещанИн\n1\nмИзерный\n1\nмозаИчный\n1\nмолЯщий\n1\nмусоропровОд\n1\nмытАрство\n1\nнавралА\n1\nнагнУтый\n1\nнаделИт\n1\nнадОлго\n1\nнадорвалАсь\n1\nнажИвший\n1\nнАжитый\n1\nнажитА\n1\nназвалАсь\n1\nнакренИться\n1\nнакренИтся\n1\nналилА\n1\nналИвший\n1\nналитА\n1\nнамЕрение\n1\nнанЯвший\n1\nнарвалА\n1\nнарОст\n1\nнасорИт\n1\nнАчал\n1\nначалА\n1\nнАчали\n1\nначАвший\n1\nначАв\n1\nначАвшись\n1\nнАчатый\n1\nначатА\n1\nнЕдруг\n1\nнедУг\n1\nнекролОг\n1\nнефтепровОд\n1\nнизведЕнный\n1\nнизведЕн\n1\nноворождЕнный\n1\nнОвости\n1\nновостЕй\n1\nнОгость\n1\nнОгтя\n1\nобеспЕчение\n1\nобзвонИть\n1\nобзвонИт\n1\nоблегчИть\n1\nоблегчИт\n1\nоблилАсь\n1\nобнЯться\n1\nобнялАсь\n1\nобогналА\n1\nободралА\n1\nободрЕнный\n1\nободрЕн\n1\nободренА\n1\nободрИться\n1\nободрИшься\n1\nобострЕнный\n1\nобострИть\n1\nодноимЕнный\n1\nодолжИть\n1\nодолжИт\n1\nозлОбить\n1\nозлОбленный\n1\nоклЕить\n1\nокружИть\n1\nокружИт\n1\nоперИться\n1\nопломбировАть\n1\nопОшлить\n1\nопОшлят\n1\nопределЕн\n1\nоптОвый\n1\nосвЕдомить\n1\nосвЕдомишь\n1\nосуждЕнный\n1\nотбелЕнный\n1\nотбылА\n1\nотдалА\n1\nотдАв\n1\nотключЕнный\n1\nоткУпорить\n1\nотозвалА\n1\nотозвАться\n1\nотозвалАсь\n1\nОтрочество\n1\nотчАсти\n1\nотымЕнный\n1\nпартЕр\n1\nпАхота\n1\nпепелИще\n1\nперезвонИть\n1\nперезвонИт\n1\nперелилА\n1\nплЕсневеть\n1\nплодоносИть\n1\nпорторИт\n1\nповторЕнный\n1\nподелЕнный\n1\nподнЯв\n1\nпозвалА\n1\nпозвонИть\n1\nпозвонИшь\n1\nпозвонИт\n1\nполилА\n1\nпонЯть\n1\nпонялА\n1\nпонЯвший\n1\nпонЯв\n1\nпОручни\n1\nпослАла\n1\nпОхороны\n1\nпохорОн\n1\nпохоронАх(пр.падеж)\n1\nпредрЕкший\n1\nпремИнуть\n1\nпремировАть\n1\nприбЫть\n1\nпрИбыл\n1\nприбылА\n1\nпрИбыло\n1\nприбЫв\n1\nпривнесЕнный\n1\nприговОр\n1\nпридАнное\n1\nпризывнИк\n1\nпризывнОй (пункт, возраст)\n1\nпризЫвный (зовущий)\n1\nпринУдить\n1\nпринЯть\n1\nпрИнял\n1\nпрИняли\n1\nпрИнятый\n1\nприобретЕние\n1\nприрОст\n1\nприручЕнный\n1\nпрожИвший\n1\nпрожОрлива\n1\nпрозорлИвый\n1\nпрозорлИва\n1\nпростынЯ\n1\nпулОвер\n1\nрассердИться\n1\nрассердИлся\n1\nрвалА\n1\nревЕнь\n1\nрОвен\n1\nсанитарИя\n1\nсвЕдущий\n1\nсверлИть\n1\nсверлИшь\n1\nсверлИт\n1\nсвЕкла\n1\nсеклА\n1\nсИлос\n1\nсиротА\n1\nсирОты\n1\nслИвовый\n1\nснялА\n1\nснЯтый\n1\nснятА\n1\nсоболЕзнование\n1\nсОгнутый\n1\nсоздалА\n1\nсоздАв\n1\nсоплемЕнный\n1\nсорвалА\n1\nсорИт\n1\nсосредотОчение\n1\nсрЕдство\n1\nсрЕдства\n1\nстатУт\n1\nстеногрАфия\n1\nстолЯр\n1\nтамОжня\n1\nтанцОвщица\n1\nтЕндер\n1\nтЕплиться\n1\nтОрты\n1\nтрИптих\n1\nтУфля\n1\nубралА\n1\nубыстрИть\n1\nУгольный (от уголь)\n1\nуглубИть\n1\nугОльный (от угол)\n1\nукраИнский\n1\nукрепИть\n1\nукрепИт\n1\nулУчшить\n1\nулУчшенный\n1\nфаксИмиле\n1\nфарфОр\n1\nфетИш\n1\nфилИстер\n1\nфлЕйтовый\n1\nфлюорогрАфия\n1\nфОрзац\n1\nформировАть\n1\nхарактЕрный (типичный)\n1\nхарАктерный (актер)\n1\nхлОпковый\n1\nходАтайствовать\n1\nхозЯева\n1\nхОленный (прич)\n1\nхОлодность\n1\nхристианИн\n1\nхристопродАвец\n1\nцЕнтер\n1\nцепОчка\n1\nцыгАн\n1\nчЕрпать\n1\nчИстильщик\n1\nшАрфа\n1\nшАрфы\n1\nшассИ\n1\nшАхтинский\n1\nшАхтинцы\n1\nшофЕр\n1\nшпрИцы\n1\nщавЕль\n1\nщЕбень\n1\nщегольскОй\n1\nщемИть\n1\nщемИт\n1\nщепА\n1\nщепОтка\n1\nщЕлка\n1\nщЕлкать\n1\nэКскурс\n1\nэкспЕртный\n1\nЭкспорт\n1\nэпилОг\n1\nюрОдивый\n1\nязыковОй (словесное выражение мыслей)\n1\nязыкОвый (орган полости рта)\n1\nяИчница\n1';
 Map<String, int> words = {};


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile([String filename = '/dictionary.txt']) async {
  final path = await _localPath + filename;
  return File(path);
}

refreshWords() async {
  print('refreshWords');
  words.clear();
  words.addAll(await readFile());
}

Future<File> createDictionary([String dict=dictionary]) async {
  final file = await localFile();
  await file.writeAsString(dict);
  await refreshWords();
  return file;
}

Future<Map<String, int>> readFile() async {
  try {
    final file = await localFile();
    String str = await file.readAsString();
    return wordsToMap(str);
  } catch (e) {
    print('read error');
    return {};
  }
}

Map<String, int> wordsToMap(String str) {
  List<String> lst = str.split('\n');
  Map<String, int> map = {};
  for (int i = 0; i < lst.length - 1; i += 2) {
    if (lst[i] != '') {
      map[lst[i]] = int.parse(lst[i + 1]);
    }
  }
  return map;
}

String wordsToString(Map<String, int> map) {
  List<String> keys = map.keys.toList();
  String str = keys[0] + '\n' + map[keys[0]].toString();
  for (int i = 1; i < keys.length; i++) {
    str += '\n' + keys[i] + '\n' + map[keys[i]].toString();
  }
  return str;
}

Future<File> writeFile(String key, int value) async {
  final file = await localFile();
  return file.writeAsString('\n' + key + '\n' + value.toString());
}

Future<File> appendFile(String key, int value) async {
  Map<String, int> map = await readFile();
  if (map.containsKey(key)) {
    final file = await localFile();
    return file.writeAsString(wordsToString(map));
  }
  List<String> lst = map.keys.toList();
  for (int i = lst.length - 1; i >= 0; i--) {
    if (lst[i] == '') lst.removeAt(i);
  }
  map.addAll({key: value});
  final file = await localFile();
  return file.writeAsString(await sortWords(map));
}

Future<File> replaceFile(String before, String after) async {
  Map<String, int> map = await readFile();
  List<String> keys = map.keys.toList();
  for (int i = 0; i < keys.length; i++) {
    if (keys[i] == before) {
      map[after] = map[keys[i]];
      map.remove(keys[i]);
      print('replace');
      break;
    }
  }
  final file = await localFile();
  return file.writeAsString(await sortWords(map));
}

Future<File> switchFile(String key, int value) async {
  Map<String, int> map = await readFile();
  map[key] =value;
  final file = await localFile();
  return file.writeAsString(await sortWords(map));
}

Future<String> sortWords(Map<String, int> map) async {
  List<String> lst2 = List<String>.from(map.keys.toList());
  List<String> lst3 = List<String>.from(map.keys.toList());
  for (int i = 0; i < lst2.length; i++) {
    lst2[i] = lst2[i].toLowerCase();
  }
  lst2.sort();
  map.keys.forEach((element) {
    int i = lst2.indexOf(element.toLowerCase());
    lst3[i] = element;
  });
  String dict = lst3[0] + '\n' + map[lst3[0]].toString();
  for (int i = 1; i < lst3.length; i++) {
    dict += '\n' + lst3[i] + '\n' + map[lst3[i]].toString();
  }
  final file = await localFile();
  file.writeAsString(dict);
  return dict;
}

