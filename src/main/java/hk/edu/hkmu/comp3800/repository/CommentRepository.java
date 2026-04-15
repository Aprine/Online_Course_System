package hk.edu.hkmu.comp3800.repository;

import hk.edu.hkmu.comp3800.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
java.util.List<hk.edu.hkmu.comp3800.model.Comment> findByAuthor(hk.edu.hkmu.comp3800.model.User author);
}