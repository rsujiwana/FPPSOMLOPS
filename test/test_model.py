import pytest
from app.utils import labeling_function

def test_labeling_function():
    input_data = "This is a sample input text."
    expected_confidence = 0.90
    assert labeling_function(input_data)[0]["confidence"][0] >= expected_confidence
