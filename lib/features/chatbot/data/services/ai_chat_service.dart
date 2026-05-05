import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';

class AIChatService {
  final Dio dio;

  AIChatService(this.dio);

  Future<String> sendMessage(
      String message, String userId, String cohort) async {
    try {
      final response = await dio.post(
        ApiEndpoints.chat,
        data: {
          'message': message,
          'user_id': userId,
          'cohort': cohort,
        },
      );
      return response.data['response'] as String;
    } catch (e) {
      // Fallback to local responses if API fails
      return _getLocalResponse(message, cohort);
    }
  }

  String _getLocalResponse(String message, String cohort) {
    final lowerMsg = message.toLowerCase();

    // Common nutrition questions and answers in Swahili
    if (lowerMsg.contains('ugali') || lowerMsg.contains('wanga')) {
      return 'Ugali ni chanzo kizuri cha wanga. Kijiko kimoja cha ugali (250g) kina kalori 375. Kwa mtu mzima, inashauriwa kula vijiko 2-3 kwa mlo mmoja. Ongeza mboga na protini kwa lishe bora.';
    } else if (lowerMsg.contains('mjamzito') || lowerMsg.contains('mimba')) {
      return 'Mama mjamzito anahitaji lishe bora yenye protini, chuma, na folate. Ongeza mboga za majani, maharage, samaki, na matunda. Pia tumia vidonge vya folic acid kama ulivyoshauriwa na daktari. Kila siku, hakikisha unakula milo mitatu yenye virutubisho.';
    } else if (lowerMsg.contains('kupunguza') || lowerMsg.contains('uzito')) {
      return 'Kupunguza uzito kwa afya: punguza sukari na vyakula vya mafuta, ongeza mboga na matunda, kunywa maji ya kutosha (lita 2 kwa siku), na fanya mazoezi kama kutembea dakika 30 kila siku. Epuka vinywaji vyenye sukari.';
    } else if (lowerMsg.contains('lishe') || lowerMsg.contains('afya')) {
      return 'Lishe bora inajumuisha vikundi vyote vya chakula: wanga (ugali, wali), protini (samaki, nyama, maharage), mboga na matunda, na mafuta yenye afya. Hakikisha unakula milo mitatu kwa siku na kunywa maji ya kutosha.';
    } else if (lowerMsg.contains('mtoto') || lowerMsg.contains('watoto')) {
      return 'Watoto wanahitaji lishe bora kwa ukuaji. Wape maziwa ya mama hadi miezi 6, kisha ongeza vyakula vya ziada kama uji, matunda yaliyopondwa, na mboga. Watoto wenye umri wa miaka 1-5 wanapaswa kula milo 3 na vitafunio 2 kwa siku.';
    } else {
      return 'Mimi ni msaidizi wako wa lishe. Unaweza kuniuliza kuhusu vyakula, mapishi, lishe bora, au jinsi ya kudhibiti uzito. Ninawezaje kukusaidia leo?';
    }
  }
}
