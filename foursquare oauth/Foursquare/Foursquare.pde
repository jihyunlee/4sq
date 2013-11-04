//
// Jihyun Lee
// hellojihyun.com | jihyun.lee@nyu.edu
//
// this sketch is for foursquare oauth using oauthP5 and controlP5
// download libraries here:
// -- http://nytlabs.com/oauthp5/
// -- http://www.sojamo.de/libraries/controlP5/
//

import oauthP5.apis.Foursquare2Api;
import oauthP5.oauth.*;
import controlP5.*;
import java.util.Scanner;

final String BASE_URL = "https://api.foursquare.com/v2/";
final String USER_CHECKINS = "users/self/checkins";
final String CLIENT_ID = "YOUR_APP_CLIENT_ID";
final String CLIENT_SECRET = "YOUR_APP_CLIENT_SECRET";
final String REDIRECT_URI = "http://localhost:8888/foursquare";
final Token EMPTY_TOKEN = null;

// OAuth
OAuthService service;
Token requestToken;
String authorizationUrl;

// UI
ControlP5 cp5;
Textlabel tl, tl1, tl2;
Bang b1, b2;
Copypaste cp = new Copypaste();
final int V_KEYCODE = 86;
final int APPLE_KEYCODE = 157;

boolean success = false;

void setup() {
  size(400, 200);
  background(0);
  initUI();
  initOAuth();
}

void draw() {
  if (success) {
    background(255);
    fill(29, 175, 235);
    translate(width/2, height/2);
    textAlign(CENTER);
    text("hello foursquare!", 0, 0 );
  }
}

void initUI() {
  cp5 = new ControlP5(this);
  tl = cp5.addTextlabel("title", "Foursquare OAuth", 10, 10);
  tl1 = cp5.addTextlabel("label", "1. authorize your application here via the browser:", 10, 40);
  b1 = cp5.addBang("open", 10, 50, 20, 20);
  tl2 = cp5.addTextlabel("label2", "2. Copy the 'code' given at the end of the url and press ok below.", 10, 100);
  b2 = cp5.addBang("ok", 10, 110, 20, 20);
}

public void open() {
  link(authorizationUrl, "_new");
}
public void ok() {
  makeOAuthRequest(cp.pasteString());
}

void initOAuth() {
  service = new ServiceBuilder()
    .provider(Foursquare2Api.class)
    .apiKey(CLIENT_ID)
    .apiSecret(CLIENT_SECRET)
    .callback(REDIRECT_URI)
    .build();  
  println("--- Foursquare2's OAuth Workflow ---");
  println();

  // Obtain the Authorization URL
  println("Fetching the Authorization URL...");
  authorizationUrl = service.getAuthorizationUrl(EMPTY_TOKEN);
  println("Got the Authorization URL!");
  println();

  println("Now go and authorize your application here by clicking the OPEN button.");
  println("(in case you're curious it links to here: "+authorizationUrl+" )");
  println("Once the user logs in they will be redirected to a page that simply says 'Success'.");
  println("Copy the code after 'code=' in the url field and paste it in Processing.");
  println();
}

void makeOAuthRequest(String verifierString) {

  Verifier verifier = new Verifier(verifierString);
  println("Got the authorization code "+verifierString);
  println();

  // Trade the Request Token and Verfier for the Access Token
  println("Trading the Request Token for an Access Token...");
  Token accessToken = service.getAccessToken(EMPTY_TOKEN, verifier);
  println("Got the Access Token!");
  println("(if your curious it looks like this: " + accessToken + " )");
  println();

  // Now let's go and ask for a protected resource!
  println("Now we're going to access a protected resource...");
  OAuthRequest request = new OAuthRequest(Verb.GET, BASE_URL+USER_CHECKINS+"?oauth_token="+accessToken.getToken());
  service.signRequest(accessToken, request);
  Response response = request.send();

  println("Got it! Lets see what we found...");
  println();
  println(response.getCode());
  if (response.getCode() == 200) {
    println(response.getBody());
    println();
    println("yay!!!");

    success = true;
    tl.remove();
    tl1.remove();
    b1.remove();
    tl2.remove();
    b2.remove();
  } else {
    println("error");
  }
}

// Processing doesn't natively handle copy-paste from your OS clipboard,
// so we add the Clipboard class in the other file, and add code to handle 
// corresponding key events here.
void keyReleased()
{ 
  keys[keyCode] = false;
}
void keyPressed()
{ 
  keys[keyCode] = true;
  if ((checkKey(CONTROL) && checkKey(V_KEYCODE)) // windows
  || (checkKey(APPLE_KEYCODE) && checkKey(V_KEYCODE))) { // mac
    println("Pasted from clipboard: "+cp.pasteString());
  }
}

