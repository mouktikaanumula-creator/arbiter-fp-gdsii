import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # Lowest-numbered request always wins
    for req in range(16):
        dut.ui_in.value = req
        await FallingEdge(dut.clk)
        expected = (req & -req) if req else 0
        assert int(dut.uo_out.value) == expected, (
            f"req={req:04b}: expected {expected:04b}, got {int(dut.uo_out.value):08b}"
        )

    # All requests high: request 0 wins every cycle, others are starved
    dut.ui_in.value = 0b1111
    for _ in range(20):
        await FallingEdge(dut.clk)
        assert int(dut.uo_out.value) == 0b0001