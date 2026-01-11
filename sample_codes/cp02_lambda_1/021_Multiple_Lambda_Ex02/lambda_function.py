import os

def lambda_handler(event, context):
    operation_name = os.environ.get('OPERATION_NAME', 'unknown')
    number_a = int(event.get('a', 0))
    number_b = int(event.get('b', 0))

    plus_ans = number_a + number_b 
    minus_ans = number_a - number_b
    multiple_ans = number_a * number_b
    if number_b == 0:
        division_ans = 'na'
    else:
        division_ans = number_a / number_b

    return {
        'statusCode': 200,
        'body': f"anwers are plus_ans={plus_ans}, minus_ans={minus_ans}, multiple_ans={multiple_ans}, division_ans={division_ans}"
    }
