package hk.edu.hkmu.comp3800.repository;

import hk.edu.hkmu.comp3800.model.Vote;
import hk.edu.hkmu.comp3800.model.User;
import hk.edu.hkmu.comp3800.model.Poll;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface VoteRepository extends JpaRepository<Vote, Long> {
    // Necessary to check if a user has already voted on a specific poll so they can edit it
    Optional<Vote> findByUserAndPoll(User user, Poll poll);
    java.util.List<hk.edu.hkmu.comp3800.model.Vote> findByUser(hk.edu.hkmu.comp3800.model.User user);
}