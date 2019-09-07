Feature: Public API User functionality

  Background:
    * url 'https://gorest.co.in/public-api'


  Scenario: 1. Get All Users

    Given path 'users'
    And header Authorization = 'Bearer m-22usQLz7hWRTe1P6wqlD1d1lXcqN_3KILQ'
    When method get
    Then status 200
    # store the first name in the response into a variable called "name"
    * def name = response.result[0].first_name
    #print name in the console
    * print ' first name is: ', name + '\n'
    #assert the size of result object in the response
    And assert response.result.length == 20


  Scenario: 2. Create Users with first name "SLUser" and 2. Get all the Users for given name and do assertions. 3. Delete the created Users

    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def email01 = now() + '@gmail.com'
    * def email02 = now() + '@yahoo.com'
    * def userRequest1 =
      """
      {
        "first_name": "SLUser",
        "last_name": "user1",
        "gender": "male",
        "email" : '#(email01)',
        "status" : "active"
      }
      """

    * def userRequest2 =
      """
      {
        "first_name": "SLUser",
        "last_name": "user2",
        "gender": "female",
        "email" : '#(email02)',
        "status" : "inactive"
      }
      """

    # 1. 1 Create User 1
    Given path 'users'
    And header Authorization = 'Bearer m-22usQLz7hWRTe1P6wqlD1d1lXcqN_3KILQ'
    And request userRequest1
    When method post
    Then status 200

    * def id1 = response.result.id
    * def firstName = response.result.first_name

    # 1. 2 Create User 2
    Given path 'users'
    And header Authorization = 'Bearer m-22usQLz7hWRTe1P6wqlD1d1lXcqN_3KILQ'
    And request userRequest2
    When method post
    Then status 200

    * def id2 = response.result.id

    # 2 Get all the User by their first name
    Given path 'users'
    Given param first_name =  firstName
    And header Authorization = 'Bearer m-22usQLz7hWRTe1P6wqlD1d1lXcqN_3KILQ'
    When method get
    Then status 200

    * def User1Response = karate.jsonPath(response, "$.result[?(@.id == '" + id1 + "')]")[0]
    * def expectedEmailUser1 = karate.jsonPath(response, "$.result[?(@.id == '" + id1 + "')].email")
    * def expectedEmailUser2 = karate.jsonPath(response, "$.result[?(@.id == '" + id2 + "')].email")

    # verify result object at once .
    And match User1Response == {id:"#(id1)",first_name:"#(firstName)",last_name:"#string",gender:"male",dob:"#null",email:"#ignore",phone:"#null",website:"#null",address:"#null",status:"active",_links:"#notnull"}
    # assert that user1 email not equals to null
    And assert expectedEmailUser1 != null
    # assert that user2 email with the actual value
    And assert expectedEmailUser2[0] == email02


    # 3 After complete the test delete created users by Ids
    Given path 'users/' , id1
    And header Authorization = 'Bearer m-22usQLz7hWRTe1P6wqlD1d1lXcqN_3KILQ'
    When method delete
    Then status 200

    Given path 'users/' , id2
    And header Authorization = 'Bearer m-22usQLz7hWRTe1P6wqlD1d1lXcqN_3KILQ'
    When method delete
    Then status 200