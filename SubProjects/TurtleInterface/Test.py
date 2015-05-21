def convertToSigned(number):
        if (number > 32767):
            return number - 65536
        else:
            return number

print(convertToSigned(0xFFA5))


