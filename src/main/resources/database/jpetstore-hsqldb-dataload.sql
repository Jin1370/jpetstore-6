--
--    Copyright 2010-2025 the original author or authors.
--
--    Licensed under the Apache License, Version 2.0 (the "License");
--    you may not use this file except in compliance with the License.
--    You may obtain a copy of the License at
--
--       https://www.apache.org/licenses/LICENSE-2.0
--
--    Unless required by applicable law or agreed to in writing, software
--    distributed under the License is distributed on an "AS IS" BASIS,
--    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--    See the License for the specific language governing permissions and
--    limitations under the License.
--

-- 기존 더미 데이터 로드
--RUNSCRIPT FROM 'src/main/resources/database/jpetstore-hsqldb-data.sql';
--------------------------


INSERT INTO sequence VALUES('ordernum', 1000);

INSERT INTO signon VALUES('j2ee','j2ee');
INSERT INTO signon VALUES('ACID','ACID');

INSERT INTO account VALUES('j2ee','yourname@yourdomain.com','ABC', 'XYX', 'OK', '901 San Antonio Road', 'MS UCUP02-206', 'Palo Alto', 'CA', '94303', 'USA',  '555-555-5555');
INSERT INTO account VALUES('ACID','acid@yourdomain.com','ABC', 'XYX', 'OK', '901 San Antonio Road', 'MS UCUP02-206', 'Palo Alto', 'CA', '94303', 'USA',  '555-555-5555');

INSERT INTO profile VALUES('j2ee','english','DOGS',1,1);
INSERT INTO profile VALUES('ACID','english','CATS',1,1);

INSERT INTO bannerdata VALUES ('FISH','<image src="../images/banner_fish.gif">');
INSERT INTO bannerdata VALUES ('CATS','<image src="../images/banner_cats.gif">');
INSERT INTO bannerdata VALUES ('DOGS','<image src="../images/banner_dogs.gif">');
INSERT INTO bannerdata VALUES ('REPTILES','<image src="../images/banner_reptiles.gif">');
INSERT INTO bannerdata VALUES ('BIRDS','<image src="../images/banner_birds.gif">');

INSERT INTO category VALUES ('FISH','Fish','<image src="../images/fish_icon.gif"><font size="5" color="blue"> Fish</font>');
INSERT INTO category VALUES ('DOGS','Dogs','<image src="../images/dogs_icon.gif"><font size="5" color="blue"> Dogs</font>');
INSERT INTO category VALUES ('REPTILES','Reptiles','<image src="../images/reptiles_icon.gif"><font size="5" color="blue"> Reptiles</font>');
INSERT INTO category VALUES ('CATS','Cats','<image src="../images/cats_icon.gif"><font size="5" color="blue"> Cats</font>');
INSERT INTO category VALUES ('BIRDS','Birds','<image src="../images/birds_icon.gif"><font size="5" color="blue"> Birds</font>');

INSERT INTO product VALUES ('FI-SW-01','FISH','Angelfish','<image src="../images/fish1.gif">Salt Water fish from Australia');
INSERT INTO product VALUES ('FI-SW-02','FISH','Tiger Shark','<image src="../images/fish4.gif">Salt Water fish from Australia');
INSERT INTO product VALUES ('FI-FW-01','FISH', 'Koi','<image src="../images/fish3.gif">Fresh Water fish from Japan');
INSERT INTO product VALUES ('FI-FW-02','FISH', 'Goldfish','<image src="../images/fish2.gif">Fresh Water fish from China');
INSERT INTO product VALUES ('K9-BD-01','DOGS','Bulldog','<image src="../images/dog2.gif">Friendly dog from England');
INSERT INTO product VALUES ('K9-PO-02','DOGS','Poodle','<image src="../images/dog6.gif">Cute dog from France');
INSERT INTO product VALUES ('K9-DL-01','DOGS', 'Dalmation','<image src="../images/dog5.gif">Great dog for a Fire Station');
INSERT INTO product VALUES ('K9-RT-01','DOGS', 'Golden Retriever','<image src="../images/dog1.gif">Great family dog');
INSERT INTO product VALUES ('K9-RT-02','DOGS', 'Labrador Retriever','<image src="../images/dog5.gif">Great hunting dog');
INSERT INTO product VALUES ('K9-CW-01','DOGS', 'Chihuahua','<image src="../images/dog4.gif">Great companion dog');
INSERT INTO product VALUES ('RP-SN-01','REPTILES','Rattlesnake','<image src="../images/snake1.gif">Doubles as a watch dog');
INSERT INTO product VALUES ('RP-LI-02','REPTILES','Iguana','<image src="../images/lizard1.gif">Friendly green friend');
INSERT INTO product VALUES ('FL-DSH-01','CATS','Manx','<image src="../images/cat2.gif">Great for reducing mouse populations');
INSERT INTO product VALUES ('FL-DLH-02','CATS','Persian','<image src="../images/cat1.gif">Friendly house cat, doubles as a princess');
INSERT INTO product VALUES ('AV-CB-01','BIRDS','Amazon Parrot','<image src="../images/bird2.gif">Great companion for up to 75 years');
INSERT INTO product VALUES ('AV-SB-02','BIRDS','Finch','<image src="../images/bird1.gif">Great stress reliever');

INSERT INTO supplier VALUES (1,'XYZ Pets','AC','600 Avon Way','','Los Angeles','CA','94024','212-947-0797');
INSERT INTO supplier VALUES (2,'ABC Pets','AC','700 Abalone Way','','San Francisco ','CA','94024','415-947-0797');

INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-1','FI-SW-01',16.50,10.00,1,'P','Large');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-2','FI-SW-01',16.50,10.00,1,'P','Small');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-3','FI-SW-02',18.50,12.00,1,'P','Toothless');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-4','FI-FW-01',18.50,12.00,1,'P','Spotted');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-5','FI-FW-01',18.50,12.00,1,'P','Spotless');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-6','K9-BD-01',18.50,12.00,1,'P','Male Adult');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-7','K9-BD-01',18.50,12.00,1,'P','Female Puppy');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-8','K9-PO-02',18.50,12.00,1,'P','Male Puppy');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-9','K9-DL-01',18.50,12.00,1,'P','Spotless Male Puppy');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-10','K9-DL-01',18.50,12.00,1,'P','Spotted Adult Female');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-11','RP-SN-01',18.50,12.00,1,'P','Venomless');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-12','RP-SN-01',18.50,12.00,1,'P','Rattleless');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-13','RP-LI-02',18.50,12.00,1,'P','Green Adult');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-14','FL-DSH-01',58.50,12.00,1,'P','Tailless');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-15','FL-DSH-01',23.50,12.00,1,'P','With tail');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-16','FL-DLH-02',93.50,12.00,1,'P','Adult Female');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-17','FL-DLH-02',93.50,12.00,1,'P','Adult Male');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-18','AV-CB-01',193.50,92.00,1,'P','Adult Male');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-19','AV-SB-02',15.50, 2.00,1,'P','Adult Male');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-20','FI-FW-02',5.50, 2.00,1,'P','Adult Male');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-21','FI-FW-02',5.29, 1.00,1,'P','Adult Female');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-22','K9-RT-02',135.50, 100.00,1,'P','Adult Male');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-23','K9-RT-02',145.49, 100.00,1,'P','Adult Female');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-24','K9-RT-02',255.50, 92.00,1,'P','Adult Male');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-25','K9-RT-02',325.29, 90.00,1,'P','Adult Female');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-26','K9-CW-01',125.50, 92.00,1,'P','Adult Male');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-27','K9-CW-01',155.29, 90.00,1,'P','Adult Female');
INSERT INTO  item (itemid, productid, listprice, unitcost, supplier, status, attr1) VALUES('EST-28','K9-RT-01',155.29, 90.00,1,'P','Adult Female');

INSERT INTO inventory (itemid, qty ) VALUES ('EST-1',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-2',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-3',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-4',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-5',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-6',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-7',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-8',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-9',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-10',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-11',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-12',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-13',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-14',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-15',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-16',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-17',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-18',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-19',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-20',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-21',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-22',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-23',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-24',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-25',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-26',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-27',10000);
INSERT INTO inventory (itemid, qty ) VALUES ('EST-28',10000);



-- =======================================================
-- Refined Test Data for Review Board (20 entries)
-- 5 Pet Types x 4 Reviews each (Balanced Sentiment)
-- Tags limited to max 2 per review
-- =======================================================

-- 1. DOGS
INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('j2ee', 'Dog', 'I was hesitant about adopting a Golden Retriever because I live in a small house, but he has been an absolute blessing. He is incredibly patient with my toddler and learns tricks faster than any dog I have ever seen. Truly man''s best friend.', 'Golden Retriever is patient and great with kids', 'Positive', '#FamilyFriendly,#Smart');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('ACID', 'Dog', 'This Bulldog might look grumpy, but he is the biggest sweetheart. He spends most of the day sleeping on the rug and snoring loudly. He requires very little exercise, making him the perfect companion for my relaxed lifestyle.', 'Bulldog is lazy and affectionate', 'Positive', '#Lazy,#Affectionate');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('alice', 'Dog', 'My Dalmation is beautiful, but oh my god, the energy level is insane. I have to take him for a 5km run every morning. If you are an active runner, this is the dog for you. If you like watching TV on the couch, look for another breed.', 'High energy dog for active owners only', 'Neutral', '#Active');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('dave', 'Dog', 'The Labrador puppy has destroyed my home. In just one week, he chewed through two pairs of expensive sneakers and a wooden chair leg. I provide plenty of toys, but he prefers destroying my personal belongings.', 'Puppy is extremely destructive', 'Negative', '#Destructive,#Chewing');


-- 2. CATS
INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('english', 'Cat', 'My Persian cat is like a living cloud. She is so fluffy and soft. Every evening when I sit down to read a book, she quietly jumps on my lap and purrs until she falls asleep. A perfect indoor pet.', 'Persian cat is fluffy and quiet', 'Positive', '#Fluffy,#LapCat');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('japanese', 'Cat', 'I adopted a Manx, and he is basically a dog in a cat''s body. He follows me from room to room and even plays fetch with a small ball! The lack of a tail makes him look so unique and cute.', 'Manx cat acts like a dog', 'Positive', '#Social,#Playful');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('j2ee', 'Cat', 'I love her, but the shedding is out of control. I find white cat hair on my black clothes, in my coffee, and even in the fridge. She is a sweet cat, but if you have allergies or hate cleaning, stay away.', 'Excessive shedding is a problem', 'Neutral', '#Shedding,#Messy');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('alice', 'Cat', 'I bought three different expensive scratching posts, but this cat still prefers my vintage leather armchair. The leather is completely ruined with deep claw marks. I tried sprays and tapes, but nothing stops him.', 'Cat ruins furniture despite scratching posts', 'Negative', '#Scratching,#Destructive');


-- 3. BIRDS
INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('carol', 'Bird', 'This Amazon Parrot is the funniest pet I have ever owned. He learned to mimic the sound of the microwave and my laugh. We have actual conversations, and he loves dancing to music.', 'Parrot mimics sounds and dances', 'Positive', '#Funny,#Talking');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('dave', 'Bird', 'I got a pair of Finches, and watching them is better than TV. They are busy building their nest all day, and their soft chirping in the morning is so peaceful. They don''t like being held, but they are wonderful to watch.', 'Finches are peaceful and interesting', 'Positive', '#Relaxing');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('english', 'Bird', 'The Parrot is cool, but nobody warned me about the noise level. He starts screaming at the top of his lungs at sunrise (6 AM). It is nature''s alarm clock that you cannot turn off.', 'Parrot is extremely loud in the morning', 'Neutral', '#Noisy');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('j2ee', 'Bird', 'I tried to hand-feed the Parrot, and he bit my finger so hard it bled. He seems to hate everyone except my wife. He hisses whenever I walk by the cage. I am actually afraid of my own pet.', 'Parrot is aggressive and bites', 'Negative', '#Aggressive,#Biting');


-- 4. FISH
INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('alice', 'Fish', 'The Koi pond in my backyard has become my sanctuary. Feeding them by hand is such a meditative experience. They are huge, colorful, and seem to recognize me when I approach the water.', 'Koi pond provides stress relief', 'Positive', '#Beautiful,#StressRelief');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('bob', 'Fish', 'Goldfish are the perfect starter pet for my 5-year-old son. He named his fish "Captain Splash" and takes responsibility for feeding him every morning. Great way to teach responsibility.', 'Goldfish are great starter pets for kids', 'Positive', '#KidsFriendly,#EasyCare');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('carol', 'Fish', 'The Angelfish are stunning to look at, but they are bullies. They keep chasing and nipping at the smaller fish in my community tank. I eventually had to buy a tank divider to keep peace.', 'Angelfish are aggressive to others', 'Neutral', '#Aggressive');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('japanese', 'Fish', 'Do not put the Tiger Shark with other fish! The description said it was semi-aggressive, but it ate three of my neon tetras in one night. Now I have one fat shark and an empty tank.', 'Shark ate all other fish', 'Negative', '#Predator,#Loss');


-- 5. REPTILES
INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('j2ee', 'Reptile', 'I never thought a reptile could be affectionate, but my Iguana loves being scratched on the head. He sits on my shoulder while I work on the computer. A very cool and misunderstood pet.', 'Iguana is affectionate and cool', 'Positive', '#Cool');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('ACID', 'Reptile', 'The Rattlesnake is mesmerizing to watch. The patterns on its scales are like a work of art. I have created a desert-themed terrarium for him. Note: strictly for looking, not touching!', 'Snake is beautiful to watch', 'Positive', '#Beautiful,#Fascinating');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('alice', 'Reptile', 'The Lizard is okay, but honestly, he is basically a "pet rock". He hides under his log for 20 hours a day and doesn''t move. It is not very entertaining for guests or kids.', 'Lizard is inactive and boring', 'Neutral', '#Inactive,#Boring');

INSERT INTO review (username, pet_type, content, summary, sentiment, tags) VALUES
    ('dave', 'Reptile', 'Nightmare scenario! The Snake escaped its enclosure because the latch was loose. We couldn''t find him for two days. My wife refused to sleep in the house until we found him curled up in a shoe.', 'Snake escaped due to faulty cage', 'Negative', '#Escaped,#Scary');