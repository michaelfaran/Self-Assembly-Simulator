from particle import Particle  # A class defined for each particle.
from simulation_cfg import SimulationCfg
import numpy as np
import random
import utils
import math

# Self defined functions.
from target import Target

# The target is created in the load configuration.
from typing import List, Union, Tuple

# What the function except to get (integer etc), would output error but continue if not included.
from exceptions import TooManyParticlesError

# Self defined exception, If more particles than board.


class Board:
    entropy: int
    cfg: SimulationCfg
    particles: List[Particle]
    # Vector of particles. This contains informations about the grid as well, and where the particle number on the grid.
    grid: np.ndarray
    # Array of dimenon n is created
    targets: List[Target]
#Michael changed here 16/1
    def __init__(self, cfg, output_file, start_at_target = False, seed_pivot = 0):
        # This is a function of the board. Each indented function is part of the class.
        self.output_file = output_file
        self.cfg = cfg
        self.listed = np.zeros((self.cfg.num_of_particles , 1), int)
        self.adjacency_matrix_encoding_factor = 10 ** (math.floor(math.log10(self.get_num_of_targets())) + 1)
        self.targets = self.initialize_targets()
        if seed_pivot == 1:
            self.particles = self.initialize_particles_list(start_at_target)
            self.grid = self.initialize_grid_seed(
                cfg.length, cfg.num_of_particles, start_at_target
            )
            self.update_particles_list_seed(start_at_target)
            #self. initialize_image_grid_seed(
             #   cfg.length, cfg.num_of_particles, start_at_target
            #)
            self.image_grid = self.initialize_grid_image_seed(cfg.length)
            self.seed_matrix = self.initizalize_seed_matrix(self.adjacency_matrix_encoding_factor)
            self.seed_pivot = 1
        else:
            self.particles = self.initialize_particles_list(start_at_target)
            self.grid = self.initialize_grid(
                cfg.length, cfg.num_of_particles, start_at_target
            )
        self.adjacency_matrix = self.initizalize_adjacency_matrix(self.adjacency_matrix_encoding_factor)
        self.current_target = -1
        self.time_in_target = -1
        self.entropy_add = 0
        self.energy_add = 0
        self.energy_add1 = 0
        self.energy_add2 = 0
        self.entropy_add1 = 0
        self.entropy_add2 = 0
        #michael adds here a total distance for average
        self.total_dist = 0

    # Each object in Python has self.attribute (same as field). In the class all is intetned.
    # This is from object oriented. Self inside the object is to say act on me. Each
    def initialize_grid(self, length: int, num_of_particles: int, start_at_target):
        """
        Initializes grid.
        Gets list of particles, and randomly populates them in the grid.
        Not necessraly random for start at target if given start a traget NUMBER.
        Returns the grid.
        """
        grid = np.full(
            (length, length), -1, int
        )  # Particle slots, -1 represents no particle, intialzation of grid with -1, no particle definition.
        coordinates = [
            (i, j) for i in range(length) for j in range(length)
        ]  # Coordinates set, prepares list of coordinates.

        if start_at_target is False:
            random.shuffle(coordinates)
        # Shuffle the coordinates.
        else:
            self.set_particles_at_target(coordinates, start_at_target)

        for i in range(num_of_particles):
            x, y = coordinates[i]
            grid[x][y] = i
            self.particles[i].x, self.particles[i].y = x, y
        return grid

    def initialize_grid_seed(self, length: int, num_of_particles: int, start_at_target):
        """
        Initializes grid.
        Gets list of particles, and randomly populates them in the grid.
        Not necessraly random for start at target if given start a traget NUMBER.
        Returns the grid.
        """

        grid = np.full(
            (length, length), -1, int
        )  # Particle slots, -1 represents no particle, intialzation of grid with -1, no particle definition.
        coordinates = [
            (i, j) for i in range(length) for j in range(length)
        ]  # Coordinates set, prepares list of coordinates.

        #random.shuffle(coordinates)
        # Shuffle the coordinates.
        if start_at_target is False:
            self.set_particles_at_target_seed(coordinates, 0)
        # Shuffle the coordinates.
        else:
            self.set_particles_at_target_seed(coordinates, start_at_target)


        for i in range(num_of_particles):
            x, y = coordinates[i]
            grid[x][y] = i
            self.particles[i].x, self.particles[i].y = x, y
        # was
        self.targets[start_at_target].particles_grid = self.target_original
        #for target_num in range(self.config.num_of_instances):
         #   self.targets[target_num].particles_grid = self.target_original[target_num]

        return grid

    def initialize_grid_image_seed(self, length: int):
        """
        Initializes grid.
        Gets list of particles, and randomly populates them in the grid.
        Not necessraly random for start at target if given start a traget NUMBER.
        Returns the grid.
        """
        particles_super_saiyan = []
        mapping_vec = np.zeros((self.cfg.num_of_particles, 1), int)-1
        num_par_ss = 0
        for i in range(self.cfg.num_of_particles):
            er = self.listedd[i]
            #was if condition er.item() == 1
            if er.item() != 0:
                particles_super_saiyan.append(self.particles[i])
                num_par_ss = num_par_ss + 1
        image_grid = np.full(
            (length, length), -1, int
        )  # Particle slots, -1 represents no particle, intialzation of grid with -1, no particle definition.

        for i in range(num_par_ss):
            image_grid[particles_super_saiyan[i].x][particles_super_saiyan[i].y] = particles_super_saiyan[i].id
            mapping_vec[i] = particles_super_saiyan[i].id
        self.num_par_ss = num_par_ss
        self. particles_super_saiyan = particles_super_saiyan
        self.mapping_vec = mapping_vec
        return image_grid

    def get_num_of_targets(self):
        num_of_targets = 0
        for config in self.cfg.targets_cfg:
            for i in range(config.num_of_instances):
                num_of_targets += 1
        return num_of_targets

    def initialize_particles_list(self, start_at_target):
        if start_at_target is False:
            return [
                Particle(i, random.randrange(0, len(self.targets)))
                for i in range(self.cfg.num_of_particles)
            ]
        return [Particle(i, start_at_target) for i in range(self.cfg.num_of_particles)]





    def initialize_targets(self) -> List[Target]:
        """
        Returns list of randomly built targets
        """
        targets = []
        id = 0
        freedist = 105 + 48
        for config in self.cfg.targets_cfg:
            for i in range(config.num_of_instances):
                targets.append(
                    Target(
                        id,
                        self.cfg.num_of_particles,
                        config.weak_interaction,
                        config.strong_interaction,
                        config.local_drive,
                        self.adjacency_matrix_encoding_factor
                    )
                )
                #Michael add to add targets that are far one from another
                if i != 0:
                    if self.calc_distance_from_targetss(targets,i) < freedist:
                        targets.append(
                            Target(
                                id,
                                self.cfg.num_of_particles,
                                config.weak_interaction,
                                config.strong_interaction,
                                config.local_drive,
                                self.adjacency_matrix_encoding_factor
                            )
                        )


                id += 1
        return targets

    def initizalize_adjacency_matrix(self, encoding_factor):
        adjacency_matrix = np.zeros(
            (self.cfg.num_of_particles, self.cfg.num_of_particles), int
        )
        adjacency_matrix[:] = -1
        # The default for no particle neighbour is -1
        for x in range(self.cfg.length):
            for y in range(self.cfg.length):
                if -1 == self.grid[x][y]:  # if no particle there.
                    continue
                neighbors = utils.get_neighboring_elements(
                    self.grid, (x, y), self.cfg.is_cyclic
                )
                # boubdary conditions is defined in the grid configuration file. returns hashmap\dictionary.
                for direction, element in neighbors.items():
                    adjacency_matrix[self.grid[x][y]][element] = (
                        encoding_factor * self.particles[self.grid[x][y]].inner_state
                        + self.particles[element].inner_state
                    )
                adjacency_matrix[self.grid[x][y]][self.grid[x][y]] = (
                    encoding_factor * self.particles[self.grid[x][y]].inner_state
                    + self.particles[self.grid[x][y]].inner_state
                )
                # direction and element is extracting the matrix index in a location one by one and put it in the adjaency matrix.
        return adjacency_matrix

    def calculate_particle_energy(self, particle: Particle) -> Union[int, float]:
        """
        Gets particle id, returns the current energy the particle adds to the system
        (energy with it being there vs. no particle being there).
        """
        p_target = self.targets[particle.inner_state]
        energy = 0
        for direction, neighbor_id in utils.get_neighboring_elements(
            self.grid, particle.get_coordinates()
        ).items():
            n_target = self.targets[self.particles[neighbor_id].inner_state]
            energy += 0.5 * (
                p_target.get_energy(particle.id, neighbor_id)
                + n_target.get_energy(particle.id, neighbor_id)
            )

        return energy

    def turn(self, turn_num, turn_callback):
        particle = random.choice(self.particles)
        # Return a random choice from the list
        self.physical_move(particle)
        # Try physical move with Metropolis condition
        particle = random.choice(self.particles)
        # Chose another random particle
        energy1 = self.energy_add
        entropy1 = self.entropy_add
        self.state_change(particle)
        entropy2 = self.entropy_add
        energy2 = self.energy_add
        self.entropy_add1 = entropy1
        self.entropy_add2 = entropy2
        self.energy_add1 = energy1
        self.energy_add2 = energy2
        # Choose each one in random.
        # Add entropy.
        # Gets accsess to the board, and what turn number are we in.
        return turn_callback(self, turn_num)

    def run_simulation(self, max_num_of_turns, turn_callback, run_index, entropy_vec, energy_vec, num_targets, mu, j, Ja, results_dir, run_indexz):
        self.distance_vec = np.zeros((max_num_of_turns , num_targets), int)
        self.mu = mu
        self.j = j
        self.num_targets = num_targets
        self.run_indexz = run_indexz
        self.results_dir = results_dir
        self.strong_interaction = Ja
        distances = [self.cfg.num_of_particles ** 2]  # distance from targets along realization. bins of 5000-mean.
        for turn_num in range(max_num_of_turns):
            if not self.turn(turn_num, turn_callback):
                # if the callback says we should stop
                entropy_vec[turn_num, 1] = self.entropy_add1
                energy_vec[turn_num, 1] = self.energy_add1
                try:
                    entropy_vec[turn_num, 2] = self.entropy_add2
                    energy_vec[turn_num, 2] = self.energy_add2
                    pass
                except:
                    entropy_vec[turn_num, 1] = self.entropy_add2
                    energy_vec[turn_num, 1] = self.energy_add2
                    pass
                #distance_vec[turn_num] = min(self.calc_distance_from_targets())
                return entropy_vec
                # break

            #self.output_file.write("time in target: {}\n".format(self.time_in_targets))
            #print("time in target: {}\n".format(self.time_in_targets))
            #self.output_file.write("tfas: {}\n".format(turn_num))
            #self.output_file.write("minimum distance bin: {}\n".format(min(distances)))
            #print("tfas: {}\n".format(turn_num))
            #print("minimum distance bin: {}\n".format(min(distances)))
            #utils.save_distance_figure(f"j{self.targets[0].strong_interaction}r{run_index} distances_graph", distances)
           # distance_vec[turn_num] = min(self.calc_distance_from_targets())
            entropy_vec[turn_num] = (self.entropy_add1, self.entropy_add2)
            energy_vec[turn_num] = (self.energy_add1, self.energy_add2)
            #entropy_vec[turn_num, 2] = self.entropy_add2
            #energy_vec[turn_num, 2] = self.energy_add2
        turn_callback(self, turn_num, finished=True)

    def physical_move(self, particle: Particle) -> None:
        """
        Gets particle, and attempting to make a physical move according to
        energy difference metropolis query.
        """
        direction = random.choice(list(utils.neighbor_directions.keys()))
        # Take all possible directions. neighbor_directions are the dictionary,. Dictionary.keys, are turning into list. and then random takes 1 of the 4 options randomly). Value is the delta.
        direction_delta = utils.neighbor_directions[direction]
        # Direction is from the dictionary the way a praticle will go next step (up, bottom etc)
        # plus B.C. such as 2D grid.
        new_coordinates = utils.add_coordinates(
            particle.get_coordinates(),
            direction_delta,
            self.cfg.length,
            self.cfg.is_cyclic,
        )
        # This was chosen instead of just adding delta due to boundary conditions.
        if not self.is_move_allowed(new_coordinates):
            self.entropy_add = 0
            self.energy_add = 0
            return

        old_energy = self.calculate_particle_energy(particle)
        # All the energy of the particle contribution to total energy.
        old_coordinates = particle.get_coordinates()

        # move particle and recalculate energy
        self.do_move_particle(particle, new_coordinates)
        new_energy = self.calculate_particle_energy(particle)
        # New energy after particle motion.
        new_neighbors = utils.get_neighboring_elements(
            self.grid, new_coordinates, self.cfg.is_cyclic
        )
        # Here we take all the new neihbours ot he particle. if the move is accepted, we keep it, and zero the neihgbors.
        kenb = utils.metropolis(-(new_energy - old_energy))
        if utils.metropolis(-(new_energy - old_energy)):
            # add entropy of step
            self.entropy_add = math.log(
                (
                    utils.metropolis_part_1(-(new_energy - old_energy))
                    / utils.metropolis_part_1((new_energy - old_energy))
                )
            )
            self.energy_add = new_energy - old_energy
            # update adjacency matrix
            self.adjacency_matrix[:, particle.id] = -1
            # I will forget mine.
            self.adjacency_matrix[particle.id, :] = -1
            # They will forget me.
            self.adjacency_matrix[particle.id][particle.id] = (
                self.adjacency_matrix_encoding_factor * particle.inner_state + particle.inner_state
            )
            # This is due to how we keep the particle and its neighbours new state in the neighbouring matrix. MIGHT BE REFACORTED.
            for n in new_neighbors.values():
                self.adjacency_matrix[particle.id][n] = (
                    self.adjacency_matrix_encoding_factor * particle.inner_state + self.particles[n].inner_state
                )
                self.adjacency_matrix[n][particle.id] = (
                    self.adjacency_matrix_encoding_factor * self.particles[n].inner_state + particle.inner_state
                )
            return

        # if the move is rejected, we revert it
        self.do_move_particle(particle, old_coordinates)
        self.entropy_add = 0
        self.energy_add = 0

        return

    def is_move_allowed(self, new_coordinates: Tuple[int]) -> bool:
        """
        Gets particle and movement direction (up/down/left/right) and cyclicity, and decides
        if the move is allowed (bounds & occupation considerations).
        """
        if utils.is_coordinates_in_bounds(
            new_coordinates, self.cfg.length, self.cfg.length
        ):
            return -1 == self.grid[new_coordinates[0]][new_coordinates[1]]

        return False

    def state_change(self, particle: Particle) -> None:
        """
        Handles the inner state change attempt of a particle.
        """
        old_energy = self.calculate_particle_energy(particle)
        original_state = particle.inner_state

        # pick a new state and calc energy in new state
        new_state = random.randrange(0, len(self.targets))
        particle.inner_state = new_state
        new_energy = self.calculate_particle_energy(particle)

        # calculate local drive, Michael will go through this again.
        neighbors = utils.get_neighboring_elements(
            self.grid, particle.get_coordinates(), self.cfg.is_cyclic
        )
        num_of_neighbors_in_original_state = len(
            [
                n
                for n in neighbors.values()
                if self.particles[n].inner_state == original_state
            ]
        )
        num_of_neighbors_in_new_state = len(
            [
                n
                for n in neighbors.values()
                if self.particles[n].inner_state == new_state
            ]
        )
        local_drive = 0

        if num_of_neighbors_in_original_state >= 2:
            local_drive -= self.targets[original_state].local_drive
        if num_of_neighbors_in_new_state >= 2:
            local_drive += self.targets[new_state].local_drive
            AA = utils.metropolis_part_1(-(new_energy - old_energy) + local_drive)
            BB = utils.metropolis_part_1((new_energy - old_energy) + local_drive)
            aaaa = math.log(AA / BB)
        # self.entropy_add = math.log((utils.metropolis_part_1(-(new_energy - old_energy) + local_drive)/utils.
        # metropolis_part_1((new_energy - old_energy) - local_drive)))

        # Check change probabilty and edit adjacency_matrix.
        kenb = utils.metropolis(-(new_energy - old_energy) + local_drive)
        if utils.metropolis(-(new_energy - old_energy) + local_drive):
            for n in neighbors.values():
                self.adjacency_matrix[particle.id][n] = (
                    self.adjacency_matrix_encoding_factor * new_state + self.particles[n].inner_state
                )
                self.adjacency_matrix[n][particle.id] = (
                    self.adjacency_matrix_encoding_factor * self.particles[n].inner_state + new_state
                )
            self.adjacency_matrix[particle.id][particle.id] = self.adjacency_matrix_encoding_factor * new_state + new_state
            self.entropy_add = math.log(
                (
                    utils.metropolis_part_1(-(new_energy - old_energy) + local_drive)
                    / utils.metropolis_part_1((new_energy - old_energy) - local_drive)
                )
            )
            self.energy_add = new_energy - old_energy
            return

        # if change rejected, revert state
        particle.inner_state = original_state
        self.entropy_add = 0
        self.energy_add = 0

        return

    def do_move_particle(self, particle, destination_coordinates):
        self.grid[particle.x][particle.y] = -1  # no particle
        self.grid[destination_coordinates[0]][
            destination_coordinates[1]
        ] = particle.id  # move particle on grid
        particle.x, particle.y = (
            destination_coordinates[0],
            destination_coordinates[1],
        )  # update particle coordinates

    # **The neibougring matrix are compared, due to rotation and transaltation symmetries.  A key point that might be troubl
    # some. To further explain the project book.
    def calc_distance_from_targets(self):
        distances = []
        for i in self.targets:
            distances.append(
                np.count_nonzero(self.adjacency_matrix != i.adjacency_matrix)
            )

        return distances

    def calc_distance_from_targetss(self,targets, i):
        distances = 0
        j = i-1
        distances = np.count_nonzero(targets[i].adjacency_matrix != targets[j].adjacency_matrix)
        return distances

    def calc_distance_from_seed(self):

        distances = []

        ssss = np.where(~(self.seed_matrix == 0 | np.eye(self.seed_matrix.shape[0], dtype=bool)),
                        self.adjacency_matrix, -10)
        wssss = np.where(ssss == -10)
        Tattva = self.adjacency_matrix[wssss]
        distances = np.size(np.where(Tattva != -1))
        return distances

    def set_particles_at_target(self, coordinates, target_num):
        target_grid = self.targets[target_num].particles_grid
        particles_array_length = int(self.cfg.num_of_particles ** 0.5)

        for i in range(particles_array_length):
            for j in range(particles_array_length):
                coordinates[target_grid[i][j]] = (i, j)


    def set_particles_at_target_seed(self, coordinates, target_num):
        #we will define the target grid by target_num
        #mem = self.targets[target_num].particles_grid
        #for i in range (self.config.num_of_instances):
         #   target_grid = self.targets[i].particles_grid
          #  mem[i] = target_grid.tolist()
        target_grid = self.targets[target_num].particles_grid
        particles_array_length = int(self.cfg.num_of_particles ** 0.5)
        powerhouse = self.cfg.seed_matrix
        #3 shuffles the wanted particles with the 2, so we will know for sure

        self.seed_grid = target_grid
        mem = target_grid.tolist()
        #particles_array_length = int(self.cfg.num_of_particles ** 0.5)
        #powerhouse = self.cfg.seed_matrix
        #occupied list
        argg_list = []
        self.listedd = np.zeros((self.cfg.num_of_particles , 1), int)
        self.schindler = []
        self.schindler3 = []

        for i in range(particles_array_length):
            for j in range(particles_array_length):
                #was powerhouse[i][j] == 2 in if condition, this decides the non random fate of particles at the target grid states, but still on the target grid
                if powerhouse[i][j] % 10 != powerhouse[i][j] and (powerhouse[i][j] != 0):
                    midd = (i + 0.5 * (np.sqrt(len(coordinates))-2)-1, j + 0.5 * (np.sqrt(len(coordinates))-2)-1)
                    middd = (int(midd[0]), int(midd[1]))
                    coordinates[target_grid[i][j]] = middd
                    #coordinates[target_grid[i][j]] = (i + 0.5 * (np.sqrt(len(coordinates))-1), j + 0.5 * (np.sqrt(len(coordinates))-1))
                    argg_list.append([i, j])
                    self.listedd[target_grid[i][j]] = int((powerhouse[i][j]-powerhouse[i][j] % 10)/10)
                    #self.schindler[target_grid[i][j]] = 1
                    #self.schindler.append(target_grid[i][j])

                #probably not commonly used the following one, its meaning is still in the target greed of 1, but start with random inital condition
                elif powerhouse[i][j] == 1:
                    #midd = (i + 0.5 *
                      #      (np.sqrt(len(coordinates))), j +  0.5 * (np.sqrt(len(coordinates)))-1)
                    midd = (
                    i + 0.5 * (np.sqrt(len(coordinates)) - 2) - 1, j + 0.5 * (np.sqrt(len(coordinates)) - 2) - 1)
                    middd = (int(midd[0]), int(midd[1]))
                    coordinates[target_grid[i][j]] = middd
                    #coordinates[target_grid[i][j]] = (i + 0.5 * (np.sqrt(len(coordinates))-1), j + 0.5 * (np.sqrt(len(coordinates))-1))
                    argg_list.append([i, j])
                    #self.schindler[target_grid[i][j]] = 1
                    #self.schindler.append(target_grid[i][j])
                    #Will probably be used, start at another state, still in the target e want, but its location will be randomized with other coordinates from the target grid, hence starting from a complicated seed most common scenario
                elif powerhouse[i][j] == 2:
                    #midd = (i + 0.5 *
                     #       (np.sqrt(len(coordinates))), j + 0.5 * (np.sqrt(len(coordinates)))-1)
                    midd = (
                    i + 0.5 * (np.sqrt(len(coordinates)) - 2) - 1, j + 0.5 * (np.sqrt(len(coordinates)) - 2) - 1)
                    middd = (int(midd[0]), int(midd[1]))
                    coordinates[target_grid[i][j]] = middd
                    #coordinates[target_grid[i][j]] = (i + 0.5 * (np.sqrt(len(coordinates))-1), j + 0.5 * (np.sqrt(len(coordinates))-1))
                    argg_list.append([i, j])
                    self.schindler.append(target_grid[i][j])
                    #self.schindler[target_grid[i][j]] = int(target_grid[i][j])
                elif powerhouse[i][j] == 3:
                    #midd = (i + 0.5 *
                     #       (np.sqrt(len(coordinates))), j + 0.5 * (np.sqrt(len(coordinates)))-1)
                    #The Cucko method, hence all the 3 take here the place of 2 later on
                    midd = (
                    i + 0.5 * (np.sqrt(len(coordinates)) - 2) - 1, j + 0.5 * (np.sqrt(len(coordinates)) - 2) - 1)
                    middd = (int(midd[0]), int(midd[1]))
                    coordinates[target_grid[i][j]] = middd
                    #coordinates[target_grid[i][j]] = (i + 0.5 * (np.sqrt(len(coordinates))-1), j + 0.5 * (np.sqrt(len(coordinates))-1))
                    argg_list.append([i, j])
                    self.schindler3.append(target_grid[i][j])
                    #self.schindler[target_grid[i][j]] = int(target_grid[i][j])
        for i in range(particles_array_length):
            for j in range(particles_array_length):
                #was before (powerhouse[i][j] != 1) & (powerhouse[i][j] != 2), if powerhouse here is zero, just do not put it in the grid
                if powerhouse[i][j] == 0:
                    #self.seed_grid[i][j] = -1
                    coordinates[target_grid[i][j]] = (
                        random.randrange(0, self.cfg.length), random.randrange(0, self.cfg.length))
                    while True in (ele == coordinates[target_grid[i][j]] for ele in argg_list):
                        coordinates[target_grid[i][j]] = (random.randrange(0, self.cfg.length), random.randrange(0, self.cfg.length))
        new = self.schindler.copy()
        new3 = self.schindler3.copy()
        random.shuffle(new)
        coordinates2 = coordinates.copy()
        for i in range(len(self.schindler)):
            coordinates[self.schindler[i]] = coordinates2[new[i]]
        coordinates3 = coordinates.copy()
        if len(self.schindler) > len(self.schindler3):
            #here we swap between the 2 and the 3
            for i in range(len(self.schindler3)):
                coordinates[self.schindler[i]] = coordinates3[self.schindler3[i]]
                coordinates[self.schindler3[i]] = coordinates3[self.schindler[i]]
        # self.schindler = argg_list
        #y = [i[j] for i in coordinates for j in range(len(i))]
        #coordinates = y
        self.target_original = np.array(mem)
        #for i in range(self.config.num_of_instances):
         #   self.target_original[i] = np.array(mem[i])

    def update_particles_list_seed(self, start_at_target):
        mark = np.zeros((self.cfg.num_of_particles), int)
        for i in range(self.cfg.num_of_particles):
            er = self.listedd[i]
            #was equal 1 in the if condition
            if er.item() != 0:
                mark[i] = self.listedd[i]-1
                #mark[i] = start_at_target
            else:
                try:
                    mark[i] = random.randrange(0, len(self.targets))
                except:
                    print("Oops!  That was no valid number.  Try again...")

        mark = mark.astype(int)
        for i in range(self.cfg.num_of_particles):
            self.deterministic_state_change(mark[i].item(), self.particles[i])


        #return [Particle.inner_state(i, mark[i].item()) for i in range(self.cfg.num_of_particles)]



    def deterministic_state_change(self, new_state, particle: Particle):
        """
        Handles the inner state change attempt of a particle.
        """

        # if change rejected, revert state
        particle.inner_state = new_state

        return
# If we choose to start in target, what types etc.

    def initizalize_seed_matrix(self, encoding_factor):
        adjacency_matrix = np.zeros(
            (self.cfg.num_of_particles, self.cfg.num_of_particles), int
        )
        adjacency_matrix[:] = -1
        # The default for no particle neighbour is -1
        aaa = self.mapping_vec
        aab = np.squeeze(aaa)
        mapping_vec = aab.tolist()


        for x in range(self.cfg.length):
            for y in range(self.cfg.length):
                if -1 == self.image_grid[x][y]:  # if no particle there.
                    continue
                neighbors = utils.get_neighboring_elements(
                    self.image_grid, (x, y), self.cfg.is_cyclic
                )
                # boubdary conditions is defined in the grid configuration file. returns hashmap\dictionary.

                #create mapping between element and id
                try:
                   # matches1 = [z for z in mapping_vec if z[0] == self.image_grid[x][y]]
                    #element1 = matches1[0][0]
                   #matches1 = mapping_vec(self.image_grid[x][y])
                   element1 = mapping_vec.index(self.image_grid[x][y])
                except:
                    print("An exception occurred")
                for direction, element in neighbors.items():
                        #matches = mapping_vec( element.item())
                        element2 = mapping_vec.index(element.item())
                        try:
                            adjacency_matrix[self.image_grid[x][y]][element] = (
                            encoding_factor * self. particles_super_saiyan[element1].inner_state
                            + self. particles_super_saiyan[element2].inner_state
                            )
                        except:
                            print("An exception occurred")
                adjacency_matrix[self.image_grid[x][y]][self.image_grid[x][y]] = (
                    encoding_factor * self. particles_super_saiyan[element1].inner_state
                    + self. particles_super_saiyan[element1].inner_state
                )


                # direction and element is extracting the matrix index in a location one by one and put it in the adjaency matrix.
        return adjacency_matrix