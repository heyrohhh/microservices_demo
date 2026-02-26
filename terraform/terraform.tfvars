services = {
  "adtask-service" = {
    min_capacity = 1
    max_capacity = 3
    cpu_target = 70
    mem_target = 75
    desired_count = 2
  }

  "cart-service" ={
    min_capacity = 1
    max_capacity = 5
    cpu_target = 65
    mem_target = 70
    desired_count = 2
  }

  "checkout-service" = {
    min_capacity = 1
    max_capacity = 4
    cpu_target = 70
    mem_target = 75
    desired_count= 2
   
  }

 "currency-service" = {
    min_capacity = 1
    max_capacity = 3
    cpu_target = 60
    mem_target = 75
    desired_count   = 2
 }

 "email-service" = {
    min_capacity = 1
    max_capacity = 3
    cpu_target = 60
    mem_target = 75
    desired_count = 2
 }
 
 "loadgenrator-service" = {
    min_capacity = 1
    max_capacity = 4
    cpu_target = 70
    mem_target = 75
    desired_count   = 2
 }

 "payment" = {
    min_capacity = 1
    max_capacity = 5
    cpu_target = 70
    mem_target = 75
    desired_count   = 1
 }

 "product" = {
    min_capacity = 1
    max_capacity = 5
    cpu_target = 70
    mem_target = 75
    desired_count   = 1
 }


   "shipping" ={
    min_capacity =1
    max_capacity =5
    cpu_target = 65
    mem_target = 70
    desired_count= 1
   }

   
    "shoppingassistant" = {
       min_capacity= 1
       max_capacity =3
       cpu_target = 65
       mem_target = 70
       desired_count=1
    }

    "recomandation-service" ={
       min_capacity= 1
       max_capacity =3
       cpu_target = 65
       mem_target = 70
       desired_count=1
    }

    "redis" = {
  min_capacity  = 1
  max_capacity  = 1 
  cpu_target    = 70
  mem_target    = 75
  desired_count = 2
}

}

