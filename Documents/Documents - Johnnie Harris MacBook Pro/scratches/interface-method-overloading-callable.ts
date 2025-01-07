interface ClockInterface {
  currentTime: Date;

  setTime(): void;
}

interface ClockJohn extends ClockInterface {
  setTime: () => any;
}

class Clock implements ClockInterface {
  currentTime: Date = new Date("December 17, 1995 03:24:00");
  setTime = () => (this.currentTime = new Date());

  constructor(h: number, m: number) {
  }

  getAsNewType(o: ClockInterface): ClockJohn {
    return o as ClockJohn;
  }
}

const c = new Clock(12, 30);

console.log(c.currentTime);
c.setTime();
console.log(c.currentTime);

const d = new Clock(12, 30);
console.log(d.currentTime);
const o: ClockJohn = d.getAsNewType(d);
o.setTime();
console.log(o.currentTime);
