package login.hashing_algorithm;

import java.security.NoSuchAlgorithmException;

public class HashingAlgorithm {
  public static void main(String[] args) throws NoSuchAlgorithmException {
    String originalPassword = "password";
    String generatedSecuredPasswordHash = Bcrypt.hashpw(originalPassword, Bcrypt.gensalt(12));
    System.out.println(generatedSecuredPasswordHash);

    boolean matched = Bcrypt.checkpw(originalPassword, generatedSecuredPasswordHash);
    System.out.println(matched);
  }
}