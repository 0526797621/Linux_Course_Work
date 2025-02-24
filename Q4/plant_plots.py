import matplotlib.pyplot as plt
import sys
import argparse

#plant = "Rose"
#height_data = [50, 55, 60, 65, 70]  # Height data over time (in cm)
#leaf_count_data = [35, 40, 45, 50, 55]  # Leaf count over time
#dry_weight_data = [2.0, 2.0, 2.1, 2.1, 3.0] S # Dry weight over time (in grams)

parser = argparse.ArgumentParser(description="Generate plant growth plots.")
parser.add_argument('--plant', required=True, help="Name of the plant")
parser.add_argument('--height', required=True, help="Height data over time (in cm)", type=int, nargs='+')
parser.add_argument('--leaf_count', required=True, help="Leaf count data over time", type=int, nargs='+')
parser.add_argument('--dry_weight', required=True, help="Dry weight data over time (in grams)", type=float, nargs='+')
args = parser.parse_args()

plant = args.plant
height_data = args.height
leaf_count_data = args.leaf_count
dry_weight_data = args.dry_weight

# Print out the plant data (optional)
print(f"Plant: {plant}")
print(f"Height data: {height_data} cm")
print(f"Leaf count data: {leaf_count_data}")
print(f"Dry weight data: {dry_weight_data} g")

# Scatter Plot - Height vs Leaf Count
plt.figure(figsize=(10, 6))
plt.scatter(height_data, leaf_count_data, color='b')
plt.title(f'Height vs Leaf Count for {plant}')
plt.xlabel('Height (cm)')
plt.ylabel('Leaf Count')
plt.grid(True)
plt.savefig(f"{plant}_scatter.png")
plt.close()  # Close the plot to prepare for the next one

# Histogram - Distribution of Dry Weight
plt.figure(figsize=(10, 6))
plt.hist(dry_weight_data, bins=5, color='g', edgecolor='black')
plt.title(f'Histogram of Dry Weight for {plant}')
plt.xlabel('Dry Weight (g)')
plt.ylabel('Frequency')
plt.grid(True)
plt.savefig(f"{plant}_histogram.png")
plt.close()  # Close the plot to prepare for the next one

# Line Plot - Plant Height Over Time
# Number of weeks dynamically based on the length of height_data
weeks = [f'Week {i+1}' for i in range(len(height_data))]
plt.figure(figsize=(10, 6))
plt.plot(weeks, height_data, marker='o', color='r')
plt.title(f'{plant} Height Over Time')
plt.xlabel('Week')
plt.ylabel('Height (cm)')
plt.grid(True)
plt.savefig(f"{plant}_line_plot.png")
plt.close()  # Close the plot

# Output confirmation
print(f"Generated plots for {plant}:")
print(f"Scatter plot saved as {plant}_scatter.png")
print(f"Histogram saved as {plant}_histogram.png")
print(f"Line plot saved as {plant}_line_plot.png")
