package hk.edu.hkmu.comp3800.repository;

import hk.edu.hkmu.comp3800.model.Lecture;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LectureRepository extends JpaRepository<Lecture, Long> {
}