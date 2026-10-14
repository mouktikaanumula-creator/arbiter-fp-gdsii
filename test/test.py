import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # Only component 0 requests -> component 0 granted
    dut.ui_in.value = 0b0001
    await ClockCycles(dut.clk, 2)
    assert int(dut.uo_out.value) == 0b0001

    # Components 0 and 3 request -> component 0 always wins (fixed priority)
    dut.ui_in.value = 0b1001
    await ClockCycles(dut.clk, 2)
    assert int(dut.uo_out.value) == 0b0001