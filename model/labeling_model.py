from pyabsa import AspectTermExtraction as ATEPC, available_checkpoints

# you can view all available checkpoints by calling available_checkpoints()
checkpoint_map = available_checkpoints()

aspect_extractor = ATEPC.AspectExtractor('multilingual',
                                         auto_device=True,  # False means load model on CPU
                                         cal_perplexity=True,
                                         )

def label_data(text):
    # Implementasi pelabelan dengan model yang sudah dilatih
    result = aspect_extractor.predict([text],
                         save_result=True,
                         print_result=True,  # print the result
                         ignore_error=True,  # ignore the error when the model cannot predict the input
                         )

    output_file = "result.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=4)
        
    return result

