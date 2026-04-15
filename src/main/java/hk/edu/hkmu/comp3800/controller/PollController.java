package hk.edu.hkmu.comp3800.controller;

import hk.edu.hkmu.comp3800.model.Poll;
import hk.edu.hkmu.comp3800.model.PollOption;
import hk.edu.hkmu.comp3800.model.User;
import hk.edu.hkmu.comp3800.model.Vote;
import hk.edu.hkmu.comp3800.repository.PollOptionRepository;
import hk.edu.hkmu.comp3800.repository.PollRepository;
import hk.edu.hkmu.comp3800.repository.UserRepository;
import hk.edu.hkmu.comp3800.repository.VoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@Controller
public class PollController {

    @Autowired
    private PollRepository pollRepository;

    @Autowired
    private PollOptionRepository pollOptionRepository;

    @Autowired
    private VoteRepository voteRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/poll/{id}")
    public String viewPollPage(@PathVariable Long id, Model model, Authentication authentication) {
        Optional<Poll> pollOpt = pollRepository.findById(id);
        
        if (pollOpt.isPresent()) {
            Poll poll = pollOpt.get();
            model.addAttribute("poll", poll);
            model.addAttribute("options", poll.getOptions());
            model.addAttribute("comments", poll.getComments());

            // Check if logged-in user has already voted to pre-select their option
            if (authentication != null && authentication.isAuthenticated()) {
                User currentUser = userRepository.findByUsername(authentication.getName());
                Optional<Vote> existingVote = voteRepository.findByUserAndPoll(currentUser, poll);
                existingVote.ifPresent(vote -> model.addAttribute("userVoteId", vote.getSelectedOption().getId()));
            }

            return "poll"; // Resolves to /WEB-INF/jsp/poll.jsp
        }
        return "redirect:/index";
    }

    @PostMapping("/poll/vote")
    public String submitVote(
            @RequestParam Long pollId,
            @RequestParam Long optionId,
            Authentication authentication) {

        User currentUser = userRepository.findByUsername(authentication.getName());
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        PollOption selectedOption = pollOptionRepository.findById(optionId).orElseThrow();

        Optional<Vote> existingVoteOpt = voteRepository.findByUserAndPoll(currentUser, poll);

        if (existingVoteOpt.isPresent()) {
            // User is changing their vote
            Vote existingVote = existingVoteOpt.get();
            PollOption previousOption = existingVote.getSelectedOption();

            if (!previousOption.getId().equals(selectedOption.getId())) {
                // Decrement old option, increment new option
                previousOption.setVoteCount(previousOption.getVoteCount() - 1);
                selectedOption.setVoteCount(selectedOption.getVoteCount() + 1);
                
                pollOptionRepository.save(previousOption);
                pollOptionRepository.save(selectedOption);

                existingVote.setSelectedOption(selectedOption);
                voteRepository.save(existingVote);
            }
        } else {
            // New vote
            Vote newVote = new Vote();
            newVote.setUser(currentUser);
            newVote.setPoll(poll);
            newVote.setSelectedOption(selectedOption);
            
            selectedOption.setVoteCount(selectedOption.getVoteCount() + 1);
            
            pollOptionRepository.save(selectedOption);
            voteRepository.save(newVote);
        }

        return "redirect:/poll/" + pollId;
    }
}