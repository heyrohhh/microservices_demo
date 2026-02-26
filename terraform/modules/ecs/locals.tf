locals {
  task_definitions = {
    adtask-service =aws_ecs_task_definition.adtask.arn
    cart= aws_ecs_task_definition.cart.arn
    checkout-service = aws_ecs_task_definition.checkout.arn
    currency-service= aws_ecs_task_definition.currency.arn
    email-service = aws_ecs_task_definition.email.arn
    loadgenrator-service   = aws_ecs_task_definition.loadgenrator.arn
    payment = aws_ecs_task_definition.payment.arn
    product= aws_ecs_task_definition.product.arn
    recomandation-service  = aws_ecs_task_definition.recomandation.arn
    shipping = aws_ecs_task_definition.shipping.arn
    shoppingassistant= aws_ecs_task_definition.assitant.arn
    redis = aws_ecs_task_definition.redis.arn
    currency = aws_ecs_task_definition.currency.arn
  }
}