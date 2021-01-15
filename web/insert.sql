insert into department (name)
     values ('Computer ')
            , ('Electromechanical ')
            , ('Architechture')
            , ('Petrochemical');


insert into professor (name, department_id)
     values ('Dr. Hicham el mongui', 1)
            ,('Dr. Saleh Shehaby', 1)
            ,('Dr. Ahmed Ragy',2)
            ,('Dr. Logic guy',2)
            ,('Dr. Nageeb Mahfouz',3)
            ,('Dr. Saad Zaghloul',3)
            ,('Dr. Ahmed Ashtoukhy',4)
            ,('Dr. Yehya el Shazly',4 );


insert into course (name, description, professor_id)
     values ('OOP', 'Learning java', 1)
            ,('Database', 'Management systems',2 )
            ,('Mechanics', 'Forces and torques',3)
            ,('Logic', 'Wires',4)
            ,('Geometry','Lines and more lines',5)
            ,('Missing views', ':)',6)
            ,('Water Treatment','Making drinkable water',7)
            ,('Chemistry','Moles',8);