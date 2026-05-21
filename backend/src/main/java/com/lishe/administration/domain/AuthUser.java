package com.lishe.administration.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "auth_user")
public class AuthUser extends AbstractPersistableCustom<Long> implements UserDetails {
    private String username;
    @Enumerated(EnumType.STRING)
    private AppRoles roles;

    protected AuthUser() {}

    public static AuthUser fromJson(String mobile) {
        return new AuthUser(mobile);
    }

    private AuthUser(String username) {
        this.username = username;
        this.roles = AppRoles.USER;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(roles.name()));
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public String getPassword() {
        return null;// Password is not stored in this entity
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
