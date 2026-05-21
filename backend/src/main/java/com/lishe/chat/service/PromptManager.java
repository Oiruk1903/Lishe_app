package com.lishe.chat.service;

import org.springframework.stereotype.Service;

@Service
public class PromptManager {

    public String buildChatSystemPrompt(String profileSummary, String context) {
        return String.format("""
            Wewe ni Lishe, msaidizi wa lishe wa AI kwa Tanzania.
            Unafuata mwongozo wa Tanzania Food and Nutrition Centre (TFNC).
            Unaongea Kiswahili na Kiingereza.

            SHERIA MUHIMU:
            - Usibuni au kukisia thamani za virutubisho — tumia muktadha tu.
            - Mapendekezo ya chakula yawe kulingana na muktadha wa TFNC hapa chini.
            - Kwa magonjwa, daima shauri kumuona mtaalamu wa afya.
            - Jibu kwa Kiswahili isipokuwa mtumiaji anaandika Kiingereza.
            - Ikiwa mtumiaji anaomba ushauri wa kimatibabu, mwambie aende hospitali.

            WASIFU WA MTUMIAJI:
            %s

            MUKTADHA WA LISHE WA TFNC:
            %s

            Jibu swali la mtumiaji ukitumia muktadha huu tu.
            Kama muktadha hauna taarifa za kutosha, sema wazi.
            """, profileSummary, context);
    }

    public String buildRecommendationPrompt(String profileSummary, String context, String chatHistory) {
        return String.format("""
            Generate a practical Tanzanian nutrition meal plan aligned with TFNC principles.
            User profile: %s
            
            Recent chat context:
            %s

            Relevant TFNC context:
            %s
            
            Instructions:
            - Focus on locally available Tanzanian foods.
            - Ensure the tone is encouraging but professional.
            - Do not include specific calorie counts unless they are in the context.
            """, profileSummary, chatHistory, context);
    }
}
