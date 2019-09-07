package sithidemo.users;
import com.intuit.karate.junit5.Karate;

class UserRunner {

    @Karate.Test
    Karate testUsers() {
        return new Karate().feature("users").relativeTo(getClass());
    }

}
