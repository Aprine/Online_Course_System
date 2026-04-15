package hk.edu.hkmu.comp3800.component;

import hk.edu.hkmu.comp3800.model.Comment;
import hk.edu.hkmu.comp3800.model.CourseMaterial;
import hk.edu.hkmu.comp3800.model.Lecture;
import hk.edu.hkmu.comp3800.model.Poll;
import hk.edu.hkmu.comp3800.model.PollOption;
import hk.edu.hkmu.comp3800.model.User;
import hk.edu.hkmu.comp3800.repository.LectureRepository;
import hk.edu.hkmu.comp3800.repository.PollRepository;
import hk.edu.hkmu.comp3800.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.ArrayList;

@Component
public class DatabaseInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private LectureRepository lectureRepository;

    @Autowired
    private PollRepository pollRepository;

    @Override
    public void run(String... args) throws Exception {
        if (userRepository.findByUsername("teacher1") == null) {
            User teacher = new User();
            teacher.setUsername("teacher1");
            teacher.setPassword(passwordEncoder.encode("password"));
            teacher.setFullName("Admin Teacher");
            teacher.setEmail("teacher@hkmu.edu.hk");
            teacher.setPhoneNumber("12345678");
            teacher.setRole("ROLE_TEACHER");
            userRepository.save(teacher);
        }

        if (userRepository.findByUsername("student1") == null) {
            User student = new User();
            student.setUsername("student1");
            student.setPassword(passwordEncoder.encode("password"));
            student.setFullName("Test Student");
            student.setEmail("student@hkmu.edu.hk");
            student.setPhoneNumber("87654321");
            student.setRole("ROLE_STUDENT");
            userRepository.save(student);
        }

        if (lectureRepository.count() == 0) {
            User teacher = userRepository.findByUsername("teacher1");
            User student = userRepository.findByUsername("student1");

            Lecture lecture1 = new Lecture();
            lecture1.setTitle("Introduction to Web Applications");
            lecture1.setSummary("An overview of web application architecture, request/response flow, and MVC design.");

            CourseMaterial material1 = new CourseMaterial();
            material1.setFileName("Lecture 1 Notes");
            material1.setFilePath("/materials/lecture1-notes.txt");
            material1.setLecture(lecture1);
            lecture1.setMaterials(new ArrayList<>(List.of(material1)));

            Comment lecture1Comment = new Comment();
            lecture1Comment.setContent("This lecture gives a good starting point for the project.");
            lecture1Comment.setAuthor(student);
            lecture1Comment.setLecture(lecture1);
            lecture1.setComments(new ArrayList<>(List.of(lecture1Comment)));

            lectureRepository.save(lecture1);

            Lecture lecture2 = new Lecture();
            lecture2.setTitle("Spring Boot and JSP Basics");
            lecture2.setSummary("Covers controller routing, JSP rendering, and basic Spring Boot configuration.");

            CourseMaterial material2 = new CourseMaterial();
            material2.setFileName("Lecture 2 Notes");
            material2.setFilePath("/materials/lecture2-notes.txt");
            material2.setLecture(lecture2);
            lecture2.setMaterials(new ArrayList<>(List.of(material2)));

            Comment lecture2Comment = new Comment();
            lecture2Comment.setContent("The JSP examples here match the project structure nicely.");
            lecture2Comment.setAuthor(teacher);
            lecture2Comment.setLecture(lecture2);
            lecture2.setComments(new ArrayList<>(List.of(lecture2Comment)));

            lectureRepository.save(lecture2);
        }

        if (pollRepository.count() == 0) {
            User teacher = userRepository.findByUsername("teacher1");
            User student = userRepository.findByUsername("student1");

            Poll poll1 = new Poll();
            poll1.setQuestion("Which topic should be introduced next class?");

            PollOption poll1Opt1 = new PollOption();
            poll1Opt1.setOptionText("Security");
            poll1Opt1.setPoll(poll1);
            PollOption poll1Opt2 = new PollOption();
            poll1Opt2.setOptionText("Database Design");
            poll1Opt2.setPoll(poll1);
            PollOption poll1Opt3 = new PollOption();
            poll1Opt3.setOptionText("File Upload");
            poll1Opt3.setPoll(poll1);
            PollOption poll1Opt4 = new PollOption();
            poll1Opt4.setOptionText("Validation");
            poll1Opt4.setPoll(poll1);
            PollOption poll1Opt5 = new PollOption();
            poll1Opt5.setOptionText("Testing");
            poll1Opt5.setPoll(poll1);
            poll1.setOptions(new ArrayList<>(List.of(poll1Opt1, poll1Opt2, poll1Opt3, poll1Opt4, poll1Opt5)));

            Comment poll1Comment = new Comment();
            poll1Comment.setContent("Security should come first.");
            poll1Comment.setAuthor(teacher);
            poll1Comment.setPoll(poll1);
            poll1.setComments(new ArrayList<>(List.of(poll1Comment)));

            pollRepository.save(poll1);

            Poll poll2 = new Poll();
            poll2.setQuestion("How comfortable are you with Spring Boot?");

            PollOption poll2Opt1 = new PollOption();
            poll2Opt1.setOptionText("Very comfortable");
            poll2Opt1.setPoll(poll2);
            PollOption poll2Opt2 = new PollOption();
            poll2Opt2.setOptionText("Comfortable");
            poll2Opt2.setPoll(poll2);
            PollOption poll2Opt3 = new PollOption();
            poll2Opt3.setOptionText("Average");
            poll2Opt3.setPoll(poll2);
            PollOption poll2Opt4 = new PollOption();
            poll2Opt4.setOptionText("Need practice");
            poll2Opt4.setPoll(poll2);
            PollOption poll2Opt5 = new PollOption();
            poll2Opt5.setOptionText("New to it");
            poll2Opt5.setPoll(poll2);
            poll2.setOptions(new ArrayList<>(List.of(poll2Opt1, poll2Opt2, poll2Opt3, poll2Opt4, poll2Opt5)));

            Comment poll2Comment = new Comment();
            poll2Comment.setContent("Good way to check the class pace.");
            poll2Comment.setAuthor(student);
            poll2Comment.setPoll(poll2);
            poll2.setComments(new ArrayList<>(List.of(poll2Comment)));

            pollRepository.save(poll2);
        }
    }
}
