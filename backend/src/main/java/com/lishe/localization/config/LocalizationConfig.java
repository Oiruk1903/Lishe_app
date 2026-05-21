package com.lishe.localization.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;

import java.util.List;
import java.util.Locale;

@Configuration
public class LocalizationConfig {

    private static final Locale SWAHILI = Locale.forLanguageTag("sw");
    private static final List<Locale> SUPPORTED_LOCALES = List.of(SWAHILI, Locale.ENGLISH);

    @Bean
    public MessageSource messageSource() {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasename("classpath:messages");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setFallbackToSystemLocale(false);
        return messageSource;
    }

    @Bean
    public LocaleResolver localeResolver() {
        return new LocaleResolver() {
            @Override
            public Locale resolveLocale(HttpServletRequest request) {
                Locale queryLocale = resolveQueryLocale(request);
                if (queryLocale != null) {
                    return queryLocale;
                }

                Locale headerLocale = resolveHeaderLocale(request);
                return headerLocale != null ? headerLocale : SWAHILI;
            }

            @Override
            public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
                // Locale is resolved from ?lang= or Accept-Language on each request.
            }
        };
    }

    private Locale resolveQueryLocale(HttpServletRequest request) {
        String lang = request.getParameter("lang");
        if (lang == null || lang.isBlank()) {
            return null;
        }

        return normalize(lang);
    }

    private Locale resolveHeaderLocale(HttpServletRequest request) {
        if (request.getLocales() == null) {
            return null;
        }

        return request.getLocales().asIterator().hasNext()
                ? normalize(request.getLocales().asIterator().next().toLanguageTag())
                : null;
    }

    private Locale normalize(String languageTag) {
        Locale locale = Locale.forLanguageTag(languageTag.trim());
        return SUPPORTED_LOCALES.stream()
                .filter(supported -> supported.getLanguage().equalsIgnoreCase(locale.getLanguage()))
                .findFirst()
                .orElse(SWAHILI);
    }
}