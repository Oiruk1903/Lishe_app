package com.lishe.jwt.config;


import com.lishe.administration.domain.AuthUser;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.repository.AuthRepository;
import com.lishe.administration.repository.UserAccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

@Configuration
@RequiredArgsConstructor
public class JwtConfig {

    private final AuthRepository userRepo;
    private final UserAccountRepository userAccountRepository;

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        return identifier -> {
            Optional<AuthUser> user = userRepo.findByUsername(identifier);
            if (user.isPresent()) {
                AuthUser foundUser = user.get();
                return new User(
                        foundUser.getUsername(),
                        "LEGACY_NO_PASSWORD",
                        foundUser.getAuthorities()
                );
            }

            Optional<UserAccount> accountOptional = userAccountRepository.findByEmail(identifier.toLowerCase());
            if (accountOptional.isPresent()) {
                UserAccount account = accountOptional.get();
                return User.withUsername(account.getEmail())
                        .password(account.getPasswordHash())
                        .authorities(account.getRole(), "ROLE_" + account.getRole())
                        .build();
            }

            throw new UsernameNotFoundException("User not found");
        };
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public AuthenticationProvider authenticationProvider(){
        DaoAuthenticationProvider daoAuth = new DaoAuthenticationProvider();
        daoAuth.setUserDetailsService(userDetailsService());
        daoAuth.setPasswordEncoder(passwordEncoder());
        return daoAuth;
    }
}
