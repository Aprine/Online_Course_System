package hk.edu.hkmu.comp3800.repository;

import hk.edu.hkmu.comp3800.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // Custom query method required for Spring Security login
    User findByUsername(String username);
}