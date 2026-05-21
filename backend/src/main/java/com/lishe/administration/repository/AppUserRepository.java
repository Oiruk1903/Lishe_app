package com.lishe.administration.repository;

import com.lishe.administration.domain.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AppUserRepository extends JpaRepository<AppUser, Long> {
    Optional<AppUser> findByMobile(String mobile);

    Optional<AppUser> findByLisheId(String lisheId);

    @org.springframework.data.jpa.repository.Query("SELECT COALESCE(a.cohort, 'GENERAL'), COUNT(a) FROM AppUser a GROUP BY a.cohort")
    List<Object[]> countByCohort();
}
