class SasException(Exception):
    pass


class SizeError(SasException):
    pass


class TooManyParticlesError(SizeError):
    def __init__(self, n: int, size: int):
        msg = f"Grid has {size ** 2} slots, which isn't enough for {n} particles"
        super().__init__(msg)


class InvalidCfgError(Exception):
    def __init__(self):
        super().__init__("Invalid configuration exception")


class NonSquareParticlesNumber(Exception):
    def __init__(self):
        super().__init__("Particles number should be perfect square")
