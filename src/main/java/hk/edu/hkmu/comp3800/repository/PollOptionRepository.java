package hk.edu.hkmu.comp3800.repository;

import hk.edu.hkmu.comp3800.model.PollOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PollOptionRepository extends JpaRepository<PollOption, Long> {
}