package hk.edu.hkmu.comp3800.config;

import jakarta.servlet.DispatcherType; // Required to fix the redirect loop
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // FIX: Tell Spring Security to allow internal JSP loading and error handling
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                
                // Allow unregistered users to access index, registration, login, and static resources
                .requestMatchers("/", "/index", "/login", "/register", "/css/**", "/js/**", "/uploads/**", "/h2-console/**").permitAll()
                
                // Restrict teacher-specific routes
                .requestMatchers("/teacher/**").hasRole("TEACHER")
                
                // All other requests require the user to be logged in (Student or Teacher)
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/index", true)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/index")
                .permitAll()
            );

        // Required to allow the H2 console to render in a frame
        http.csrf(csrf -> csrf.ignoringRequestMatchers("/h2-console/**"));
        http.headers(headers -> headers.frameOptions(frameOptions -> frameOptions.disable()));

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
